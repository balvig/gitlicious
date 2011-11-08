class Report < ActiveRecord::Base
  belongs_to :project
  has_many :problems, :dependent => :destroy

  before_validation :set_sha, :on => :create
  before_create :run_metrics

  def self.latest
    order('created_at ASC').last
  end

  def timestamp
    created_at.to_i * 1000
  end

  private

  def run_metrics
    project.metrics.each do |metric|
      problems << metric.run
    end
  end

  def set_sha
    self.sha ||= project.current_sha
  end
end
