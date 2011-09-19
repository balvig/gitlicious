class Diagnosis < ActiveRecord::Base
  belongs_to :commit
  belongs_to :metric
  has_many :problems, :dependent => :destroy
  
  before_save :run_metric_and_cache_results
  
  def weighted_score
    @weighted_score ||= score * metric.weight
  end
  
  def change
    if commit.parent
      score - commit.parent.diagnoses.where(:metric_id => metric).first.score
    else
      0
    end
  end
  
  private
  
  def run_metric_and_cache_results
    results = metric.run(commit)
    self.log = results[:log]
    self.problems = results[:problems]
    self.score = results[:score] || problems.size
  end
end
