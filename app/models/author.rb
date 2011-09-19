class Author < ActiveRecord::Base
  
  has_many :problems
  
  def projects
    Project.all
  end
  
  def self.find_or_create_from_metadata(metadata)
    find_or_create_by_name_and_email(:name => metadata.name, :email => metadata.email)
  end
  
  def current_problems_in(project)
    project.reports.first.problems.where(:author_id => self)
  end
end
