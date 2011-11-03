class Report < ActiveRecord::Base
  belongs_to :project
  has_many :results, :dependent => :destroy
  has_many :problems, :through => :results

  validates_uniqueness_of :sha, :scope => :project_id

  before_validation :run_metrics, :set_sha

  default_scope order('created_at DESC')

  def timestamp
    created_at.to_i * 1000
  end

  def total_score
    results.all.sum(&:score)
  end

  private

  def run_metrics
    project.update_git_repository
    project.metrics.each do |metric|
      results << metric.run
    end
  end

  def set_sha
    self.sha = project.git.log(1).first.sha
  end
end
