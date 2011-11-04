require 'spec_helper'

describe Metric do

  describe ".run" do
    let(:project) { Factory(:project_with_no_metrics) }

    describe "rails_best_practices" do
      let(:metric)  { Factory(:rbp_metric, :project => project) }

      it "runs the command line tool and parses the output" do
        problems = metric.run
        problems.size.should == 1
        problem = problems.first
        problem.filename.should == 'app/models/post.rb'
        problem.line_number.should == 6
        problem.description.should == 'keep finders on their own model'
      end
    end

    describe "cleanup" do
      let(:metric)  { Factory(:cleanup_metric, :project => project) }

      it "runs the command line tool and parses the output, looking at the line after where the tag is" do
        problems = metric.run
        problems.size.should == 2

        problem = problems.first
        problem.filename.should == 'app/models/post.rb'
        problem.line_number.should == 5
        problem.description.should == 'This could be rewritten using Rails 3 syntax'

        problem = problems.last
        problem.filename.should == 'app/models/top_10.rb'
        problem.line_number.should == 3
        problem.description.should == 'This method is empty!'
      end
    end

    # describe "reek" do
    #   let(:metric) { Factory(:reek_metric) }
    #   before(:each) { metric.stub(:project).and_return(project) }
    #
    #   it "runs the command line tool and parses the output" do
    #     project.should_receive(:run).with("reek -y -c config/defaults.reek app/controllers app/helpers app/models lib").and_return("--- \n- !ruby/object:Reek::SmellWarning \n  location: \n    context: MetricsController#update\n    lines: \n    - 32\n    - 34\n    source: app/controllers/metrics_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls params twice\n    call: params\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: ProjectsController#find_author\n    lines: \n    - 53\n    - 53\n    source: app/controllers/projects_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls params twice\n    call: params\n    occurrences: 2\n  status: \n    is_active: true\n- !ruby/object:Reek::SmellWarning \n  location: \n    context: ProjectsController#find_author\n    lines: \n    - 53\n    - 53\n    source: app/controllers/projects_controller.rb\n  smell: \n    class: Duplication\n    subclass: DuplicateMethodCall\n    message: calls params[:author_id] twice\n    call: params[:author_id]\n    occurrences: 2\n  status: \n    is_active: true")
    #     result = metric.run
    #     result.score.should == 3
    #     result.problems.size.should == 3
    #     problem = result.problems.first
    #     problem.filename.should == 'app/controllers/metrics_controller.rb'
    #     problem.line_number.should == 32
    #     problem.description.should == "DuplicateMethodCall\n    message: calls params twice\n    "
    #   end
    # end

  end
end
