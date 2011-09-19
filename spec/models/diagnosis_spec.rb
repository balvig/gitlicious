require 'spec_helper'

describe Diagnosis do
  
  let(:project) { Factory(:project) }
  
  describe ".run_metric_and_save_results" do
    let(:commit) { project.commits.create!(:sha => '28f582f7fb93b76da0af7699dddd573b8c294356') }
    
    context "flog" do
      let(:metric) { Metric.find_by_name('flog') }
      
      it "stores the average flog/method score for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.log.should == "   102.9: flog total\n     8.6: flog/method average\n"
        diagnosis.score.should == 8.6
        diagnosis.problems.size.should == 0
      end
    end
  
    context "cleanup" do
      let(:metric) { Metric.find_by_name('cleanup') }
      
      it "stores the number of cleanup tags for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.log.should == "app/models/post.rb:5:  def find_valid_comments #CLEANUP: This could be rewritten using Rails 3 syntax\n"
        # diagnosis.score.should == 1
        diagnosis.problems.size.should == 1
        diagnosis.problems.first.line_number.should == 5
        diagnosis.problems.first.filename.should == 'app/models/post.rb'
        diagnosis.problems.first.description.should == 'This could be rewritten using Rails 3 syntax'
        diagnosis.problems.first.author.name.should == 'Jens Balvig'
      end
    end
  
    context "rails_best_practices" do
      let(:metric) { Metric.find_by_name('rails_best_practices') }
      
      it "stores the number of rails best practice problems for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.log.should == "./app/controllers/posts_controller.rb:50 - simplify render in controllers\n./app/controllers/posts_controller.rb:66 - simplify render in controllers\n./app/controllers/posts_controller.rb:15,36,58,74 - use before_filter for show,edit,update,destroy\n./app/helpers/application_helper.rb:1 - remove empty helpers\n./app/helpers/posts_helper.rb:1 - remove empty helpers\n./db/schema.rb:15 - always add db index (comments => [post_id])\n./app/models/post.rb:6 - keep finders on their own model\n./app/models/comment.rb:3 - remove trailing whitespace\n./app/models/post.rb:2 - remove trailing whitespace\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 9 errors.\n"
        diagnosis.score.should == 9
        diagnosis.problems.size.should == 9
        diagnosis.problems.first.line_number.should == 50
        diagnosis.problems.first.filename.should == 'app/controllers/posts_controller.rb'
        diagnosis.problems.first.description.should == 'simplify render in controllers'
        diagnosis.problems.first.author.name.should == 'Jens Balvig'
      end
    end
    
    context "rcov" do
      let(:metric) { Metric.find_by_name('rcov') }
      
      it "stores the number of uncovered code lines for the associated commit" do
        diagnosis = Diagnosis.create!(:commit => commit, :metric => metric)
        diagnosis.score.should == 9
        diagnosis.problems.size.should == 9
        diagnosis.problems.first.line_number.should == 5
        diagnosis.problems.first.filename.should == 'app/models/comment.rb'
        diagnosis.problems.first.description.should == 'if spam?'
        diagnosis.problems.first.author.name.should == 'Jens Balvig'
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