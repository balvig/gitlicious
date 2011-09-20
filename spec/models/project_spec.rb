require 'spec_helper'

describe Project do
  
  describe ".set_name" do
    let(:project) { Factory.build(:project) }
    before(:each) { project.stub(:clone_repository) }
    context "given a url ending in .git" do
      it "strips of .git" do
        project.repo_url = 'git://github.com/balvig/gitlicious_dummy.git'
        project.save
        project.name.should == 'gitlicious_dummy'
      end      
    end
    context "given a url with no extension" do
      it "grabs the last part of the path" do
        project.repo_url = 'ssh://192.168.31.21/home/git/repos/cookpad_all'
        project.save
        project.name.should == 'cookpad_all'        
      end
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
