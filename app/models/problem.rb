class Problem < ActiveRecord::Base

  belongs_to :author
  belongs_to :report
  belongs_to :metric
  delegate :project, :to => :report
  before_validation :blame

  validates_presence_of :filename, :line_number, :description, :author_id
  validates_uniqueness_of :description, :scope => [:filename, :line_number, :report_id]
  default_scope includes(:metric)

  def self.score
    all.sum(&:score)
  end

  def self.by(author = nil)
    result = scoped
    result = result.where(:author_id => author) if author
    result
  end

  def link
    "#{project.github_url}/blob/#{report.sha}/#{filename}#L#{line_number}" if project.github_url?
  end

  def score
    metric.weight
  end

  private

  def blame
    output = project.git.lib.send(:command,"blame #{filename} -L#{line_number},#{line_number} -p")
    name = output[/author\s(.+)$/,1]
    email = output[/author-mail\s<(.+)>$/,1]
    self.author = Author.find_or_create_by_name_and_email(name,email)
    project.authors << author unless project.authors.exists?(author)
    rescue Git::GitExecuteError => e
      logger.error(e.message)
  end
end
