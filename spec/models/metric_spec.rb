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
        project.should_receive(:run).with("reek -y -c config/defaults.reek app/controllers app/helpers app/models lib").and_return("--- \n- !ruby/object:Reek::SmellWarning \n  location: \n    context: ApplicationController\n    lines: \n    - 1\n    source: app/controllers/application_controller.rb\n  smell: \n    class: IrresponsibleModule\n    subclass: IrresponsibleModule\n    message: has no descriptive comment\n    module_name: ApplicationController\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController\n    lines: \n    - 1\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: IrresponsibleModule\n    subclass: IrresponsibleModule\n    message: has no descriptive comment\n    module_name: PostsController\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#create\n    lines: \n    - 47\n    - 50\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls format.html twice\n    call: format.html\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#create\n    lines: \n    - 48\n    - 51\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls format.xml twice\n    call: format.xml\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#create\n    lines: \n    - 47\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: NestedIterators\n    subclass: NestedIterators\n    message: contains iterators nested 2 deep\n    depth: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#destroy\n    lines: \n    - 79\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: NestedIterators\n    subclass: NestedIterators\n    message: contains iterators nested 2 deep\n    depth: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#index\n    lines: \n    - 9\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: NestedIterators\n    subclass: NestedIterators\n    message: contains iterators nested 2 deep\n    depth: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#new\n    lines: \n    - 31\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: NestedIterators\n    subclass: NestedIterators\n    message: contains iterators nested 2 deep\n    depth: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#show\n    lines: \n    - 20\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: NestedIterators\n    subclass: NestedIterators\n    message: contains iterators nested 2 deep\n    depth: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#update\n    lines: \n    - 63\n    - 66\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls format.html twice\n    call: format.html\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#update\n    lines: \n    - 64\n    - 67\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls format.xml twice\n    call: format.xml\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#update\n    lines: \n    - 59\n    - 62\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls params twice\n    call: params\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: PostsController#update\n    lines: \n    - 63\n    source: app/controllers/posts_controller.rb\n  smell: \n    class: NestedIterators\n    subclass: NestedIterators\n    message: contains iterators nested 2 deep\n    depth: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: Comment\n    lines: \n    - 1\n    source: app/models/comment.rb\n  smell: \n    class: IrresponsibleModule\n    subclass: IrresponsibleModule\n    message: has no descriptive comment\n    module_name: Comment\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: Post\n    lines: \n    - 1\n    source: app/models/post.rb\n  smell: \n    class: IrresponsibleModule\n    subclass: IrresponsibleModule\n    message: has no descriptive comment\n    module_name: Post\n  status: \n    is_active: true")
        result = metric.run
        result.score.should == 15
        result.problems.size.should == 15
        problem = result.problems.first
        problem.filename.should == 'app/controllers/application_controller.rb'
        problem.line_number.should == 1
        problem.description.should == 'has no descriptive comment'
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

