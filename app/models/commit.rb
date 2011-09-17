class Commit < ActiveRecord::Base
  belongs_to :project
  belongs_to :author
  has_many :problems
  has_many :diagnoses
  validates_uniqueness_of :sha, :scope => :project_id
  before_save :set_metadata, :on => :create
  after_save :create_problems
  
  attr_accessor :cleanup #For now
  
  scope :recent, order('commited_at DESC')
  
  def timestamp
    commited_at.to_i * 1000
  end

  def metrics
    Metric.all.map(&:name)
  end
  
  def change(metric)
    if parent && send(metric).present? && parent.send(metric).present?
      send(metric) - parent.send(metric)
    else
      0
    end
  end
  
  def parent
    @parent ||= project.commits.where(:sha => parent_sha).first
  end
  
  def reset_metrics!
    self.metrics_log = ''
    metrics.keys.each do |metric|
      send("#{metric}=",nil)
    end
    set_metrics
    save!
  end
  
  def assessment
    if metrics.keys.all? {|metric|change(metric) < 0 }
      'good'
    elsif metrics.keys.all? {|metric|change(metric) > 0 }
      'bad'
    end
  end
  
  def run(command)
    checkout
    project.run(command)
  end

  private
    
  def checkout
    project.git.checkout(sha, :force => true)
  end
  
  def set_metadata
    metadata = project.git.gcommit(sha)
    self.commited_at = metadata.date
    self.name = metadata.message
    self.parent_sha = metadata.parent.try(:sha)
    self.author = Author.find_or_create_from_metadata(metadata.author)
    rescue Git::GitExecuteError => e
      logger.error(e)
  end

  def create_problems
    metrics_log.scan(/(.+:\d+.+$)/).map do |results|
      problem = Problem.build_from_log(results.first)
      problem.author = Author.find_or_create_by_name_and_email(blame(problem.filename, problem.line_number))
      problems << problem
    end
  end
  
  def blame(filename, line_number)
    checkout
    output = project.git.lib.send(:command,"blame #{filename} -L#{line_number},#{line_number} -p")
    {:name => output[/author\s(.+)$/,1], :email => output[/author-mail\s<(.+)>$/,1]}
  end
end