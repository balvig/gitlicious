require 'spec_helper'

describe Report do

  describe ".run_metrics" do
    before { require Rails.root.join('db','seeds') }
    it "runs all metrics on the project" do
      report = Report.create!(:project =>  Factory(:real_project))
      report.problems.size.should == 4
    end
  end

  describe ".set_sha" do
    it "stores the current sha hash of the project" do
      report = Report.create!(:project => Factory(:real_project))
      report.sha.should == 'a09aa5501595c95d8aa191296e7d1c0489834aa8'
    end
  end

  describe "timestamp" do
    it "returns a timestamp formatted for flot" do
      Timecop.freeze('2007-03-05'.to_date)
      Factory(:report).timestamp.should == 1173020400000
    end
  end
end
