class Problem < ActiveRecord::Base

  belongs_to :author
  belongs_to :result
  before_save :blame

  validates_presence_of :filename, :line_number

  scope :prioritized, joins(:result => :metric).order('metrics.weight DESC')
  
  def project
    result.report.project #CLEANUP: What's the best way to get to the project?
  end
  
  def covered?
    !result.report.results.joins(:metric).where(:metrics => {:name => 'rcov'}).first.problems.exists?(:filename => filename, :line_number => line_number)
  end
  
  private
  
  def blame
    output = project.git.lib.send(:command,"blame #{filename} -L#{line_number},#{line_number} -p")
    name = output[/author\s(.+)$/,1]
    email = output[/author-mail\s<(.+)>$/,1]
    self.author = Author.find_or_create_by_name_and_email(name,email)
  end
end