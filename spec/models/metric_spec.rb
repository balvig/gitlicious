require 'spec_helper'

describe Metric do
  
  let(:project) { mock('project') }
  
  describe ".run" do
    describe "rails_best_practices" do
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
    
    describe "cleanup" do
      let(:metric) { Factory(:cleanup_metric) }
      before(:each) { metric.stub(:project).and_return(project) }
      
      it "runs the command line tool and parses the output" do
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
    
    describe "reek" do
      let(:metric) { Factory(:reek_metric) }
      before(:each) { metric.stub(:project).and_return(project) }
      
      it "runs the command line tool and parses the output" do
        project.should_receive(:run).with("reek -y -c config/defaults.reek app/controllers app/helpers app/models lib").and_return("--- \n- !ruby/object:Reek::SmellWarning \n  location: \n    context: MetricsController#update\n    lines: \n    - 32\n    - 34\n    source: app/controllers/metrics_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls params twice\n    call: params\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: ProjectsController#find_author\n    lines: \n    - 53\n    - 53\n    source: app/controllers/projects_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls params twice\n    call: params\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: ProjectsController#find_author\n    lines: \n    - 53\n    - 53\n    source: app/controllers/projects_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls params[:author_id] twice\n    call: params[:author_id]\n    occurrences: 2\n  status: \n    is_active: true")
        result = metric.run
        result.score.should == 3
        result.problems.size.should == 3
        problem = result.problems.first
        problem.filename.should == 'app/controllers/metrics_controller.rb'
        problem.line_number.should == 32
        problem.description.should == "DuplicateMethodCall\n    message: calls params twice\n    "
      end
    end
    
    describe "flog" do
      let(:metric) { Factory(:flog_metric) }
      before(:each) { metric.stub(:project).and_return(project) }
      
      it "runs the command line tool and parses the output" do
        project.should_receive(:run).with("flog --continue app/controllers app/helpers app/models lib").and_return("8.7: flog total\n2.2: flog/method average\n\n3.5: Comment#message                  app/models/comment.rb:4\n3.0: Post#find_valid_comments         app/models/post.rb:5\n18.0: Problem#covered?                 app/models/problem.rb:15")
        result = metric.run
        result.score.should == 2.2
        result.problems.size.should == 3
        result.problems.map(&:filename).should == ['app/models/comment.rb','app/models/post.rb','app/models/problem.rb']
        result.problems.map(&:line_number).should == [4,5,15]
        problem = result.problems.first
        problem.filename.should == 'app/models/comment.rb'
        problem.line_number.should == 4
        problem.description.should == '3.5: Comment#message'
      end
    end
  end
end

