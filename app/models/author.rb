class Author < ActiveRecord::Base

  has_and_belongs_to_many :projects
  has_many :problems

  def self.find_or_create_from_metadata(metadata)
    find_or_create_by_name_and_email(:name => metadata.name, :email => metadata.email)
  end

end
