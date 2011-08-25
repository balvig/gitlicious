require 'spec_helper'

describe Commit do
  describe ".flog" do
    it "returns the flog score for that commit" do
      project = Factory(:project)
      commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
      commit.flog.should == 94.2
      commit = project.commits.create!(:sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff')
      commit.flog.should == 1.0
    end
  end
  
  describe ".rbp" do
    it "returns the number of rails best practice problems for that commit" do
      project = Factory(:project)
      commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
      commit.rbp.should == 1
    end
  end
  
  describe ".loc" do
    it "returns the number of lines of codes for that commit" do
      project = Factory(:project)
      commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
      commit.loc.should == 67
      commit = project.commits.create!(:sha => '1ecc5075a0e58e5b080c9130522c44fc25906cff')
      commit.loc.should == 5
    end
  end

  describe ".change" do
    before(:each) do
      @project = Factory(:project)
      @previous_build = Factory(:commit, :sha => 'abcd', :project => @project, :flog => 500, :rbp => 100)
    end
    context "no previous" do
      it "returns 0" do
        @previous_build.change(:flog).should == 0
      end
    end
    context "lower score than previous" do
      it "returns difference" do
        Factory(:commit, :parent_sha => 'abcd', :project => @project, :flog => 400).change(:flog).should == -100
      end
    end
    context "higher score than previous" do
      it "returns difference" do
        Factory(:commit, :parent_sha => 'abcd', :project => @project, :flog => 600).change(:flog).should == 100
      end
    end
    context "same score as previous" do
      it "returns 0" do
        Factory(:commit, :parent_sha => 'abcd', :project => @project, :flog => 500).change(:flog).should == 0
      end
    end
    context "previous commit with no score" do
      it "returns 0" do
        Factory(:commit, :sha => 'efgh', :project => @project, :flog => nil)
        Factory(:commit, :parent_sha => 'efgh', :project => @project, :flog => 9000).change(:flog).should == 0
      end
    end
    context "rbp" do
      it "works with other fields" do
        Factory(:commit, :parent_sha => 'abcd', :project => @project, :rbp => 110).change(:rbp).should == 10
      end
    end
  end
  
  describe ".commited_at" do
    it "returns the date of the commit" do
      project = Factory(:project)
      commit = project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
      commit.commited_at.should == Time.parse('Tue Mar 8 14:17:23 2011 +0900')
    end
  end
end
