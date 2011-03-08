require 'spec_helper'

describe Tag do
  describe "flog" do
    it "returns the flog score for that tag" do
      project = Factory(:project)
      tag = project.tags.create!(:name => 'buildsuccess/master/2')
      tag.flog.should == 94.2
      tag = project.tags.create!(:name => 'buildsuccess/master/1')
      tag.flog.should == 1.0
    end
  end
  
  describe "loc" do
    it "returns the number of lines of codes for that tag" do
      project = Factory(:project)
      tag = project.tags.create!(:name => 'buildsuccess/master/2')
      tag.loc.should == 67
      tag = project.tags.create!(:name => 'buildsuccess/master/1')
      tag.loc.should == 5
    end
  end
  
  describe "build_number" do
    context "CI tag" do
      it "returns the build number" do
        Factory(:tag, :name => 'buildsuccess/master/2').build_number.should == 2
      end      
    end
    context "other tag" do
      it "returns 0" do
        Factory(:tag, :name => 'stable').build_number.should == 0
      end
    end
  end
  
  describe "commited_at" do
    it "returns the date of the commit" do
      pending
      project = Factory(:project)
      tag = project.tags.create!(:name => 'buildsuccess/master/2')
      tag.commited_at.should == 'bleh'
    end
  end
end
