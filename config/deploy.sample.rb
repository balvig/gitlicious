require 'bundler/capistrano'

set :application, "gitlicious"
set :deploy_to, "/home/jens/#{application}"
set :scm, :git

set :branch, ENV['BRANCH'] || :master
set :ssh_options, { :forward_agent => true }

set :user, 'jens'
set :domain, 'app-gitlicious-01.ap-northeast-1.compute.internal'
set :use_sudo, false

role :web, domain
role :app, domain
role :db, domain, :primary => true


set :repository, 'git://github.com/balvig/gitlicious.git'
set :deploy_via, :remote_cache

# RVM stuff
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.2'

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

  desc "Symlink shared config file on each release."
  task :symlink_config do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
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

after 'deploy:update_code', 'deploy:symlink_config'
after 'deploy:restart', 'deploy:cleanup'