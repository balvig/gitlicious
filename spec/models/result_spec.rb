require 'spec_helper'

describe Result do
  describe ".score" do
    let(:metric) { Metric.create!(:weight => 5) }
    let(:result) { Result.create!(:metric => metric) }
    before { result.stub(:problems).and_return([mock('Problem'),mock('Problem')]) }

    it "returns the number of problems multiplied by the metric's weight" do
      result.score.should == 10
    end
  end
end
