class Problem < ActiveRecord::Base
  
  belongs_to :author
  belongs_to :diagnosis
  before_save :blame
  
  private
  
  def blame
    diagnosis.commit.checkout
    output = diagnosis.commit.project.git.lib.send(:command,"blame #{filename} -L#{line_number},#{line_number} -p")
    name = output[/author\s(.+)$/,1]
    email = output[/author-mail\s<(.+)>$/,1]
    self.author = Author.find_or_create_by_name_and_email(name,email)
  end
end