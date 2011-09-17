require 'spec_helper'

describe Diagnosis do
  
  before(:all) do
    require Rails.root.join('db','seeds')
  end
  
  let(:project) { Factory(:project) }
  
  describe ".set_log" do
    context "rails_best_practices" do
      let(:metric) { Metric.find_by_name('rails_best_practices') }
      
      it "stores the output log for that metric" do
        commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
        commit.diagnoses.create!(:metric => metric).log.should == "./app/controllers/posts_controller.rb:15,36,58,74 - use before_filter for show,edit,update,destroy\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 1 errors.\n"
      end
    end
  end
  
  describe ".set_score" do
    
    context "flog" do
      let(:metric) { Metric.find_by_name('flog') }
      
      it "sets the average flog/method score for that commit" do
        commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
        commit.diagnoses.create!(:metric => metric).score.should == 11.8
        commit = project.commits.create!(:sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff')
        commit.diagnoses.create!(:metric => metric).score.should == 1.0
      end
    end

    context "cleanup" do
      it "sets the number of cleanup tags for that commit" do
        pending
        commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
        commit.flog.should == 11.8
        commit = project.commits.create!(:sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff')
        commit.flog.should == 1.0
      end
    end

    context "rails_best_practices" do
      let(:metric) { Metric.find_by_name('rails_best_practices') }
      
      it "sets the number of rails best practice problems for that commit" do
        commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
        commit.diagnoses.create!(:metric => metric).score.should == 1
      end
    end

    context "loc" do
      it "sets the number of lines of codes for that commit" do
      pending
      commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
      commit.loc.should == 67
      commit = project.commits.create!(:sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff')
      commit.loc.should == 5
      end
    end
  end
  
  after(:all) do
    Metric.delete_all
  end
end
