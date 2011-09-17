require 'spec_helper'

describe Diagnosis do
  
  let(:project) { Factory(:project) }
  
  
  describe ".run_metric_and_save_results" do
    let(:commit) { project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b') }
    
    context "flog" do
      let(:metric) { Metric.find_by_name('flog') }
      
      it "sets the average flog/method score for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.score.should == 11.8
        diagnosis.log.should == 'belelele'
        diagnosis.problems.size.should == 0
      end
    end

    context "cleanup" do
      let(:metric) { Metric.find_by_name('cleanup') }
      
      it "sets the number of cleanup tags for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.score.should == 11
        diagnosis.log.should == 'belelele'
        diagnosis.problems.size.should == 2
      end
    end

    context "rails_best_practices" do
      let(:metric) { Metric.find_by_name('rails_best_practices') }
      
      it "sets the number of rails best practice problems for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.score.should == 1
        diagnosis.log.should == "./app/controllers/posts_controller.rb:15,36,58,74 - use before_filter for show,edit,update,destroy\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 1 errors.\n"
        diagnosis.problems.size.should == 1
      end
    end

    context "loc" do
      it "sets the number of lines of codes for that commit" do
        pending
      end
    end
  end
  
  describe ".change" do

    let(:previous_build) { Factory(:commit, :sha => 'abcd', :project => project, :flog => 500, :rbp => 100) }
    context "no previous" do
      it "returns 0" do
        previous_build.change(:flog).should == 0
      end
    end
    context "lower score than previous" do
      it "returns difference" do
        Factory(:commit, :parent_sha => 'abcd', :project => project, :flog => 400).change(:flog).should == -100
      end
    end
    context "higher score than previous" do
      it "returns difference" do
        Factory(:commit, :parent_sha => 'abcd', :project => project, :flog => 600).change(:flog).should == 100
      end
    end
    context "same score as previous" do
      it "returns 0" do
        Factory(:commit, :parent_sha => 'abcd', :project => project, :flog => 500).change(:flog).should == 0
      end
    end
    context "previous commit with no score" do
      it "returns 0" do
        Factory(:commit, :sha => 'efgh', :project => project, :flog => nil)
        Factory(:commit, :parent_sha => 'efgh', :project => project, :flog => 9000).change(:flog).should == 0
      end
    end
    context "rbp" do
      it "works with other fields" do
        Factory(:commit, :parent_sha => 'abcd', :project => project, :rbp => 110).change(:rbp).should == 10
      end
    end
  end
  
  describe ".create_problems" do
   context "from rails best practices" do
     it "creates an array of problems" do
       commit = project.commits.create!(:sha => 'c756ac8ce6ed1e37b354521467251aa7894e4f7b')
       commit.problems.size.should == 3
       commit.problems.last.line_number.should == 2
       commit.problems.last.filename.should == './app/models/post.rb'
       commit.problems.last.description.should == 'remove trailing whitespace'
       commit.problems.last.author.name.should == 'Jens Balvig'
       commit.problems.last.metric_type.should == 'rbp'
     end       
   end
   context "from cleanup tags" do
     it "creates an array of problems" do
       commit = project.commits.create!(:sha => 'f34405cb690d6cec6b3a0743437d9301d3ff7f3d')
       commit.problems.size.should == 3
       commit.problems.last.line_number.should == 3
       commit.problems.last.filename.should == 'app/models/post.rb'
       commit.problems.last.description.should == 'This could be rewritten using Rails 3 syntax'
       commit.problems.last.author.name.should == 'Jens Balvig'
       commit.problems.last.metric_type.should == 'cleanup'
     end
   end
  end
end