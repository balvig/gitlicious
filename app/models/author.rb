class Author < ActiveRecord::Base
  
  has_many :commits
  has_many :projects, :through => :commits
  
  def self.find_or_create_from_metadata(metadata)
    find_or_create_by_name_and_email(:name => metadata.name, :email => metadata.email)
  end
  
  def current_problems_in(project)
    project.commits.first.problems.where(:author_id => self)
  end
end
