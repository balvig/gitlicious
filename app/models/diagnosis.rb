class Diagnosis < ActiveRecord::Base
  belongs_to :commit
  belongs_to :metric
  before_save :set_log, :set_score
  
  private
  
  def set_log
    self.log = metric.run(commit, commit.project.target_folders)
  end
  
  def set_score
    self.score = metric.score_from_log(log)
  end
end
