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
        File.exists?(Rails.root.join('spec','fixtures','repos','gitlicious_dummy')).should be_true
      end
    end
  end
  
  describe ".destroy" do
    it "removes the repository when deleted" do
      project = Factory(:project, :repo_url => 'git://github.com/balvig/gitlicious_dummy.git')
      project.destroy
      File.exists?(Rails.root.join('spec','fixtures','repos','gitlicious_dummy')).should_not be_true
    end
  end
  
  describe ".create_authors" do
    it "grabs authors from the git log and assigns them to the project" do
      project = Factory(:project)
      project.authors.size.should == 2
      project.authors.first.name.should == 'Jens Balvig'
      project.save
      project.reload
      project.authors.size.should == 2
    end
  end

end
