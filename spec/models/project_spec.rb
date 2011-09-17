require 'spec_helper'

describe Project do
  describe ".import_commits!" do

    let(:project) { Factory(:project) }
    
    it "imports new commits" do
      project.import_commits!
      project.commits.size.should == 2
      project.commits.map(&:sha).should == ['05f41f5eb9970332a1d53f184091be946e5bed1b','1ecc5075a0e58e5b080c9130522c44fc25906cff']
    end
    it "doesn't duplicate existing commits" do
      project.commits.create!(:name => '05f41f5eb9970332a1d53f184091be946e5bed1b')
      project.import_commits!
      project.reload
      project.commits.size.should == 2
    end
  end
  
  describe ".repo_url" do
    context "given a url" do
      it "clones the project" do
        project = Factory(:project, :repo_url => 'git://github.com/balvig/gitlicious_dummy.git', :name => 'gitlicious_dummy')
        File.exists?(Rails.root.join('repos','gitlicious_dummy')).should be_true
      end
    end
  end
  
  describe ".destroy" do
    it "removes the repository when deleted" do
      project = Factory(:project, :repo_url => 'git://github.com/balvig/gitlicious_dummy.git', :name => 'gitlicious_dummy')
      project.destroy
      File.exists?(Rails.root.join('repos','gitlicious_dummy')).should_not be_true
    end
  end
end
