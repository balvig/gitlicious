require 'spec_helper'

describe Project do
  
  describe ".set_name" do
    it "automatically creates a name from the url" do
      Factory(:project, :repo_url => 'git://github.com/balvig/gitlicious_dummy.git').name.should == 'gitlicious_dummy'
    end
  end
  
  describe ".repo_url" do
    context "given a url" do
      it "clones the project" do
        project = Factory(:project, :repo_url => 'git://github.com/balvig/gitlicious_dummy.git')
        File.exists?(project.repo_path).should be_true
      end
    end
  end
  
  describe ".destroy" do
    it "removes the repository when deleted" do
      project = Factory(:project, :repo_url => 'git://github.com/balvig/gitlicious_dummy.git')
      project.destroy
      File.exists?(project.repo_path).should_not be_true
    end
  end

end
