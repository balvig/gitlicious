require 'spec_helper'

describe Metric do
  
  let(:project) { mock('project') }
  let(:commit) { mock('commit', :project => project) }
  
  describe ".run" do
    context "rails_best_practices" do
      let(:metric) { Metric.find_by_name!('rails_best_practices') }
      
      it "runs the command line tool and parses the output" do
        project.should_receive(:run).with('rails_best_practices --without-color .').and_return("./app/models/post.rb:5 - keep finders on their own model\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 1 error.")
        commit.should_receive(:checkout)
        results = metric.run(commit)
        results[:log].should == "./app/models/post.rb:5 - keep finders on their own model\n\nPlease go to http://rails-bestpractices.com to see more useful Rails Best Practices.\n\nFound 1 error."
        results[:score].should == 1
        results[:problems].size.should == 1
        problem = results[:problems].first
        problem.filename.should == './app/models/post.rb'
        problem.line_number.should == 5
        problem.description.should == 'keep finders on their own model'
      end
    end
    
    context "cleanup" do
      let(:metric) { Metric.find_by_name!('cleanup') }
      
      it "runs the command line tool and parses the output" do
        project.should_receive(:run).with('grep -r -n "#CLEANUP:" app/controllers app/helpers app/models lib').and_return("app/models/post.rb:33:  #CLEANUP: This could be rewritten using Rails 3 syntax")
        commit.should_receive(:checkout)
        results = metric.run(commit)
        results[:log].should == "app/models/post.rb:33:  #CLEANUP: This could be rewritten using Rails 3 syntax"
        results[:score].should == 1
        results[:problems].size.should == 1
        problem = results[:problems].first
        problem.filename.should == 'app/models/post.rb'
        problem.line_number.should == 33
        problem.description.should == 'This could be rewritten using Rails 3 syntax'
      end
    end
  end
end