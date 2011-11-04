require 'spec_helper'

describe Problem do
  describe ".blame" do
    let(:project) { Factory(:real_project) }

    it "creates or finds an actor, assigns it to the problem and adds as a member of the project" do
      problem = Problem.new(:filename => 'app/models/post.rb', :line_number => 3)
      problem.stub(:project).and_return(project)
      problem.save!
      problem.author.name.should == 'Jens Balvig'
      project.authors.should == [problem.author]
    end
  end
end
