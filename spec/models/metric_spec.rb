require 'spec_helper'

describe Metric do
  
  let(:project) { mock('project') }
  
  describe ".run" do
    context "rails_best_practices" do
      let(:metric) { Factory(:rbp_metric) }
      before(:each) { metric.stub(:project).and_return(project) }
        
      it "runs the command line tool and parses the output" do
        project.should_receive(:run).with('rails_best_practices --without-color .').and_return("./app/models/post.rb:5 - keep finders on their own model\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 1 error.")
        result = metric.run
        result.log.should == "./app/models/post.rb:5 - keep finders on their own model\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 1 error."
        result.score.should == 1
        result.problems.size.should == 1
        problem = result.problems.first
        problem.filename.should == 'app/models/post.rb'
        problem.line_number.should == 5
        problem.description.should == 'keep finders on their own model'
      end
    end
    
    context "cleanup" do
      let(:metric) { Factory(:cleanup_metric) }
      before(:each) { metric.stub(:project).and_return(project) }
      
      it "runs the command line tool and parses the output" do
        metric.stub(:project).and_return(project)
        project.should_receive(:run).with("grep -r -n '#CLEANUP:' app/controllers app/helpers app/models lib").and_return("app/models/post.rb:33:  #CLEANUP: This could be rewritten using Rails 3 syntax")
        result = metric.run
        result.log.should == "app/models/post.rb:33:  #CLEANUP: This could be rewritten using Rails 3 syntax"
        result.score.should == 1
        result.problems.size.should == 1
        problem = result.problems.first
        problem.filename.should == 'app/models/post.rb'
        problem.line_number.should == 33
        problem.description.should == 'This could be rewritten using Rails 3 syntax'
      end
    end
  end
end