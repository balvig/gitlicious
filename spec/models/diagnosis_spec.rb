require 'spec_helper'

describe Diagnosis do
  
  let(:project) { Factory(:project) }
  
  describe ".run_metric_and_save_results" do
    let(:commit) { project.commits.create!(:sha => 'f34405cb690d6cec6b3a0743437d9301d3ff7f3d') }
    
    context "flog" do
      let(:metric) { Metric.find_by_name('flog') }
      
      it "stores the average flog/method score for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.log.should == "    96.9: flog total\n    10.8: flog/method average\n"
        diagnosis.score.should == 10.8
        diagnosis.problems.size.should == 0
      end
    end
  
    context "cleanup" do
      let(:metric) { Metric.find_by_name('cleanup') }
      
      it "stores the number of cleanup tags for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.log.should == "app/models/post.rb:3:  #CLEANUP: This could be rewritten using Rails 3 syntax\n"
        diagnosis.score.should == 0
        diagnosis.problems.size.should == 1
        diagnosis.problems.first.line_number.should == 3
        diagnosis.problems.first.filename.should == 'app/models/post.rb'
        diagnosis.problems.first.description.should == 'This could be rewritten using Rails 3 syntax'
        diagnosis.problems.first.author.name.should == 'Jens Balvig'
      end
    end
  
    context "rails_best_practices" do
      let(:metric) { Metric.find_by_name('rails_best_practices') }
      
      it "stores the number of rails best practice problems for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.log.should == "./app/models/post.rb:5 - keep finders on their own model\n./app/controllers/posts_controller.rb:15,36,58,74 - use before_filter for show,edit,update,destroy\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 2 errors.\n"
        diagnosis.score.should == 2
        diagnosis.problems.size.should == 2
        diagnosis.problems.first.line_number.should == 5
        diagnosis.problems.first.filename.should == './app/models/post.rb'
        diagnosis.problems.first.description.should == 'keep finders on their own model'
        diagnosis.problems.first.author.name.should == 'Jens Balvig'
      end
    end
  
    context "loc" do
      it "stores the number of lines of codes for that commit" do
        pending
      end
    end
  end
  
  describe ".change" do
    
    let(:flog) { Metric.find_by_name('flog') }
    
    context "previous commit exists" do
      it "returns the difference in score" do
        previous_commit = Factory(:commit, :sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff', :project => project)
        new_commit = Factory(:commit, :sha => '05f41f5eb9970332a1d53f184091be946e5bed1b', :project => project)
        previous_diagnosis = previous_commit.diagnoses.create!(:metric => flog)
        new_diagnosis = new_commit.diagnoses.create!(:metric => flog)
        previous_diagnosis.score.should == 1.0
        new_diagnosis.score.should == 11.8
        new_diagnosis.change.should == 10.8
      end
    end
    
    context "no previous commit exists" do
      it "returns 0" do
        commit = Factory(:commit, :sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff', :project => project)
        commit.diagnoses.create!(:metric => flog).change.should == 0
      end
    end
    
  end
  
end