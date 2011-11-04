require 'spec_helper'

describe Project do

  describe ".set_name" do
    let(:project) { Factory.build(:project) }

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
    context "given a url with : as separator" do
      it "finds the project name" do
        project.repo_url = 'git@example.com:project.git'
        project.save
        project.name.should == 'project'
      end
    end
  end

  describe ".repo_url" do
    context "given a url" do
      it "clones the project" do
        project = Project.create!(:repo_url => 'git://github.com/balvig/gitlicious_dummy.git')
        File.exists?(Rails.root.join('spec','fixtures','repos','gitlicious_dummy')).should be_true
      end
    end
  end

  describe ".destroy" do
    it "removes the repository when deleted" do
      project = Project.create!(:repo_url => 'git://github.com/balvig/gitlicious_dummy.git')
      project.destroy
      File.exists?(Rails.root.join('spec','fixtures','repos','gitlicious_dummy')).should_not be_true
    end
  end

  describe ".create_default_metrics" do
    it "creates a set of default metrics" do
      project = Factory(:project)
      project.metrics.map(&:name).should == ["cleanup","rails_best_practices"]
    end
  end

  describe ".current_problems" do
    let(:project)  { Factory(:project) }
    let(:report_1) { Factory(:report, :project => project) }
    let(:report_2) { Factory(:report, :project => project) }

    before do
      Factory(:problem, :report => report_1)
      Factory(:problem, :report => report_2)
      Factory(:problem, :report => report_2)
    end

    it "returns problems associated it with the latest report" do
      project.current_problems.size.should == 2
    end
  end
end
