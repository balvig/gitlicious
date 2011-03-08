class Project < ActiveRecord::Base
  has_many :tags
  
  def update_tags!(filter = '')
    git.fetch
    git.tags.each do |tag|
      tags.create(:name => tag.name) if tag.name.include?(filter)
    end
  end
  
  def git
    @git ||= Git.open(repo_path)
  end
  
end
