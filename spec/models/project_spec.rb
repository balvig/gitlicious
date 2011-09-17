require 'spec_helper'

describe Project do
  describe ".import_commits!" do

    let(:project) { Factory(:project) }
    
    it "imports new commits" do
      project.import_commits!
      project.commits.size.should == 5
      project.commits.map(&:sha).should == ["a07ddbe7c343218d528b38d2a3a2d819d9c362f6", "f34405cb690d6cec6b3a0743437d9301d3ff7f3d", "c756ac8ce6ed1e37b354521467251aa7894e4f7b", "05f41f5eb9970332a1d53f184091be946e5bed1b", "1ecc5075a0e58e5b080c9130522c44fc25906cff"]
    end
    
    it "doesn't duplicate existing commits" do
      project.commits.create!(:sha => '05f41f5eb9970332a1d53f184091be946e5bed1b')
      project.import_commits!
      project.reload
      project.commits.size.should == 5
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
