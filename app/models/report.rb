class Report < ActiveRecord::Base
  belongs_to :project
  has_many :problems, :dependent => :destroy

  validates_uniqueness_of :sha, :scope => :project_id

  before_validation :run_metrics, :set_sha

  def self.latest
    order('created_at ASC').last
  end


  def timestamp
    created_at.to_i * 1000
  end

  private

  def run_metrics
    project.update_git_repository
    project.metrics.each do |metric|
      problems << metric.run
    end
  end

  def set_sha
    self.sha = project.git.log(1).first.sha
  end
end
