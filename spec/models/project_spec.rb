require 'spec_helper'

describe Project do
  describe ".import_commits!" do
    before(:each) do
      @project = Factory(:project)
    end
    
    context "no filter given" do
      it "imports new CI commits" do
        @project.import_commits!
        @project.commits.size.should == 2
        @project.commits.map(&:sha).should == ['05f41f5eb9970332a1d53f184091be946e5bed1b','1ecc5075a0e58e5b080c9130522c44fc25906cff']
      end
      it "doesn't duplicate existing commits" do
        @project.commits.create!(:name => '05f41f5eb9970332a1d53f184091be946e5bed1b')
        @project.import_commits!
        @project.reload
        @project.commits.size.should == 2
      end      
    end
  end
end
