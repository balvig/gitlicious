require 'spec_helper'

describe Problem do
  
  let(:project)   { Factory(:project) }
  let(:commit)    { project.commits.create!(:sha => 'f34405cb690d6cec6b3a0743437d9301d3ff7f3d') }
  let(:diagnosis) { commit.diagnoses.create!(:metric => Metric.find_by_name('flog'))}
  
  describe ".blame" do
    it "creates or finds an actor and assigns it to the problem" do
      problem = Problem.create!(:filename => 'app/models/post.rb', :line_number => 3, :description => 'This is unclear.', :diagnosis => diagnosis)
      problem.author.name.should == 'Jens Balvig'
    end
  end
  
end