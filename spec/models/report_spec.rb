require 'spec_helper'

describe Report do
  
  let(:project) { Factory(:project) }
  
  describe ".run_metrics" do
    
    it "runs metrics for all metrics assigned to the project" do
      report = Factory(:report, :project => project)
      report.results.size.should == 3
      report.problems.size.should == 10
    end
    
  end
  
  describe ".validates_uniqueness_of" do
    it "does not allow 2 of the same report" do
      report = Factory(:report, :sha => '05f41f5eb9970332a1d53f184091be946e5bed1b', :project => project)
      project.reports.build(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b').should_not be_valid
    end
  end
  
  describe ".set_sha" do
    it "stores the current sha hash of the project" do
      pending
      # report = Factory(:report, :sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff', :project => project)
      # report.author.email.should == 'jens@cookpad.com'
      # report = Factory(:report, :sha => '05f41f5eb9970332a1d53f184091be946e5bed1b', :project => project)
      # report.author.email.should == 'jens@cookpad.com'
      # report = Factory(:report, :sha => 'c756ac8ce6ed1e37b354521467251aa7894e4f7b', :project => project)
      # report.author.email.should == 'jens@balvig.com'
      # Author.count.should == 2
    end
  end
end