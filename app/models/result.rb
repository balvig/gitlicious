class Result < ActiveRecord::Base
  belongs_to :report
  belongs_to :metric
  has_many :problems, :dependent => :destroy
    
  def weighted_score
    @weighted_score ||= score * metric.weight
  end

end