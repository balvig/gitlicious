class Diagnosis < ActiveRecord::Base
  belongs_to :commit
  belongs_to :metric
  has_many :problems
  
  before_save :run_metric_and_save_results
  
  def change
    if commit.parent
      score - commit.parent.diagnoses.where(:metric => metric).score
    else
      0
    end
  end
  
  private
  
  def run_metric_and_save_results
    results = metric.run(commit)
    self.log = results[:log]
    self.score = results[:score]
    self.problems = results[:problems]
  end
end
