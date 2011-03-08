require 'spec_helper'

describe Project do
  describe ".update_tags!" do
    before(:each) do
      @project = Factory(:project)
    end
    
    context "no filter given" do
      it "imports new tags" do
        @project.update_tags!
        @project.tags.size.should == 3
        @project.tags.map(&:name).should == ['buildsuccess/master/1','buildsuccess/master/2','testing']
      end
      it "doesn't duplicate existing tags" do
        @project.tags.create!(:name => 'buildsuccess/master/1')
        @project.update_tags!
        @project.reload
        @project.tags.size.should == 3
      end      
    end
    
    context "context" do
      it "only imports tags with a certain naming" do
        @project.update_tags!('buildsuccess/master')
        @project.tags.size.should == 2
        @project.tags.map(&:name).should == ['buildsuccess/master/1','buildsuccess/master/2']
      end
    end
    
  end
end
