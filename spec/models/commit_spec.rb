require 'spec_helper'

describe Commit do
  
  let(:project) { Factory(:project) }
  
  describe ".validates_uniqueness_of" do
    it "does not allow 2 of the same commit" do
      commit = Factory(:commit, :sha => '05f41f5eb9970332a1d53f184091be946e5bed1b', :project => project)
      project.commits.build(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b').should_not be_valid
    end
  end
  
  describe ".create_diagnoses" do
    it "creates a diagnose for each metric" do
      commit = Factory(:commit, :sha => '05f41f5eb9970332a1d53f184091be946e5bed1b', :project => project)
      commit.diagnoses.map(&:metric).map(&:name).should == ['rails_best_practices','cleanup','flog']
    end
  end

  describe ".commited_at" do
   it "returns the date of the commit" do
     commit = Factory(:commit, :sha => '05f41f5eb9970332a1d53f184091be946e5bed1b', :project => project)
     commit.commited_at.should == Time.parse('Tue Mar 8 14:17:23 2011 +0900')
   end
  end

  describe ".set_metadata" do
    it "creates/assigns an author to the commit" do
      commit = Factory(:commit, :sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff', :project => project)
      commit.author.email.should == 'jens@cookpad.com'
      commit = Factory(:commit, :sha => '05f41f5eb9970332a1d53f184091be946e5bed1b', :project => project)
      commit.author.email.should == 'jens@cookpad.com'
      commit = Factory(:commit, :sha => 'c756ac8ce6ed1e37b354521467251aa7894e4f7b', :project => project)
      commit.author.email.should == 'jens@balvig.com'
      Author.count.should == 2
    end
  end
end