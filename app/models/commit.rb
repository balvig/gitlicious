class Commit < ActiveRecord::Base
  belongs_to :project
  belongs_to :author
  has_many :diagnoses, :dependent => :destroy
  has_many :problems, :through => :diagnoses
  validates_uniqueness_of :sha, :scope => :project_id
  before_save :set_metadata, :create_diagnoses
  
  default_scope order('commited_at DESC')
  
  def timestamp
    commited_at.to_i * 1000
  end
  
  def parent
    @parent ||= project.commits.where(:sha => parent_sha).first
  end
  
  def total_score
    diagnoses.all.sum(&:weighted_score)
  end
  
  def assessment
    # if metrics.keys.all? {|metric|change(metric) < 0 }
    #   'good'
    # elsif metrics.keys.all? {|metric|change(metric) > 0 }
    #   'bad'
    # end
  end
  
  def checkout
    project.git.checkout(sha, :force => true)
  end

  private
    
  def set_metadata
    metadata = project.git.gcommit(sha)
    self.commited_at = metadata.date
    self.name = metadata.message
    self.parent_sha = metadata.parent.try(:sha)
    self.author = Author.find_or_create_from_metadata(metadata.author)
    rescue Git::GitExecuteError => e
      logger.error(e)
  end
  
  def create_diagnoses
    project.metrics.each do |m|
      diagnoses.build(:metric => m)
    end
  end
  
end