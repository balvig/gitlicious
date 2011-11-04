require 'spec_helper'

describe Problem do
  describe ".score" do
    it "returns the associated metric's weight" do
      Factory.build(:problem, :metric => Factory(:metric, :weight => 10)).score.should == 10
    end
  end

  describe "#score" do
    let(:report)  { Factory(:report) }

    it "sums up all the scores for a scope of problems" do
      report.problems << Factory(:problem, :metric => Factory(:metric, :weight => 10))
      report.problems << Factory(:problem, :metric => Factory(:metric, :weight => 5))
      report.problems.score.should == 15
    end
  end

  describe "#by" do
    let(:author)       { Author.create! }
    let!(:problem_1)  { Factory(:problem, :author => author) }
    let!(:problem_2)  { Factory(:problem) }

    context "given an author" do
      it "returns problems associated with the actor" do
        Problem.by(author).should == [problem_1]
      end
    end

    context "given nil" do
      it "returns all problems" do
        Problem.by(nil).should == [problem_1, problem_2]
      end
    end

  end

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
