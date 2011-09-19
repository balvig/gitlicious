require 'spec_helper'

describe Result do
  describe ".weighted_score" do
    let(:metric) { Metric.create!(:weight => 5) }
    it "returns a result multiplied by the metric's weight" do
      Result.create!(:score => 2, :metric => metric).weighted_score.should == 10
      Result.create!(:score => 0, :metric => metric).weighted_score.should == 0
    end
  end
end