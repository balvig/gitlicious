require 'spec_helper'

describe Report do

  let(:project) { Factory(:project) }

  describe ".run_metrics" do
    it "runs metrics for all metrics assigned to the project" do
      report = Factory(:report, :project => project)
      report.problems.size.should == 3
    end
  end

  describe ".validates_uniqueness_of" do
    it "does not allow 2 of the same report" do
      report = Factory(:report, :project => project)
      project.reports.build(:sha => report.sha).should_not be_valid
    end
  end

  describe ".set_sha" do
    it "stores the current sha hash of the project" do
      report = Factory(:report, :project => project)
      report.sha.should == '1e45a341424f6fa91e0c748fe1d9094376c52835'
    end
  end
end
