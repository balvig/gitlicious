require 'spec_helper'

describe Problem do
  
  describe ".blame" do
    it "creates or finds an actor and assigns it to the problem" do
      problem = Problem.new(:filename => 'app/models/post.rb', :line_number => 3)
      problem.stub(:project).and_return(Factory(:project))
      problem.save!
      problem.author.name.should == 'Jens Balvig'
    end
  end
  
end