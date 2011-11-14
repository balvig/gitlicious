require 'bundler/capistrano'
load 'deploy/assets'

set :application, "gitlicious"
set :deploy_to, "/path/to/#{application}"
set :scm, :git

set :branch, ENV['BRANCH'] || :master
set :ssh_options, { :forward_agent => true }

set :user, 'myuser'
set :domain, 'www.mydomain.com'
set :use_sudo, false

role :web, domain
role :app, domain
role :db, domain, :primary => true

# GIT
set :repository, 'git://github.com/balvig/gitlicious.git'
set :deploy_via, :remote_cache

# WHENEVER
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

# Custom tasks
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Symlink shared config files and repos on each release."
  task :symlink_config do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/airbrake.rb #{release_path}/config/initializers/airbrake.rb"
    run "ln -nfs #{shared_path}/repos/ #{release_path}/repos"
  end

  namespace :web do
    desc 'UNTIL="16:00 MST" REASON="a database upgrade"'
    task :disable, :roles => :web do
      on_rollback { rm "#{shared_path}/system/maintenance.html" }

      require 'erb'
      deadline, reason = ENV['UNTIL'], ENV['REASON']
      maintenance = ERB.new(File.read("./app/views/layouts/maintenance.erb")).result(binding)

      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
end

before 'deploy:assets:symlink', 'deploy:symlink_config'
after 'deploy:restart', 'deploy:cleanup'
