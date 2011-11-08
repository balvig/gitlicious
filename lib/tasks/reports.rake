namespace :reports do
  desc 'Create new reports for all projects'
  task :create => :environment do
    Project.all.each do |p|
      p.reports.create!
    end
  end
end
