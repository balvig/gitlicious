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
      problem = Problem.new(:filename => 'app/models/post.rb', :line_number => 3, :description => 'Fix this')
      problem.stub(:project).and_return(project)
      problem.save!
      problem.author.name.should == 'Jens Balvig'
      project.authors.should == [problem.author]
    end
  end

  describe ".validates_uniqueness_of" do
    let(:report_1) { Factory(:report) }
    let(:report_2) { Factory(:report) }
    it "only adds the same problem for any report once" do
      Factory(:problem, :description => 'This is bad', :filename => 'config.rb', :line_number => 5, :report => report_1)
      Factory.build(:problem, :description => 'This is bad', :filename => 'config.rb', :line_number => 5, :report => report_1).should_not be_valid
      Factory.build(:problem, :description => 'This is pretty bad', :filename => 'config.rb', :line_number => 5, :report => report_1).should be_valid
      Factory.build(:problem, :description => 'This is bad', :filename => 'boot.rb', :line_number => 5, :report => report_1).should be_valid
      Factory.build(:problem, :description => 'This is bad', :filename => 'config.rb', :line_number => 8, :report => report_1).should be_valid
      Factory.build(:problem, :description => 'This is bad', :filename => 'config.rb', :line_number => 5, :report => report_2).should be_valid
    end
  end

  describe "Invalid blames should be ignored" do
    context "Given an author with the name/email Not Committed Yet/not.committed.yet" do
      it 'makes the record invalid' do
        author = Author.new(:name => 'Not Committed Yet', :email => 'not.committed.yet')
        problem = Factory.build(:problem, :author => author).should_not be_valid
      end
    end
  end
end
