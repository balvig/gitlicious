class Result < ActiveRecord::Base
  belongs_to :report
  belongs_to :metric
  has_many :problems, :dependent => :destroy

  def score
    @score ||= problems.size * metric.weight
  end

end
