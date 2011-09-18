class Author < ActiveRecord::Base
  
  def self.find_or_create_from_metadata(metadata)
    find_or_create_by_name_and_email(:name => metadata.name, :email => metadata.email)
  end
  
  def current_problems_in(project)
    project.commits.recent.first.problems.where(:author_id => self)
  end
end
