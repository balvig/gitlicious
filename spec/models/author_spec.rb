require 'spec_helper'

describe Author do
  describe "#find_or_create_from_metadata" do
    it "saves name and email and creates a new author if one doesn't exist" do
      metadata = mock('metadata', :name => 'Bob', :email => 'bob@mail.com')
      author = Author.find_or_create_from_metadata(metadata)
      author.name.should == 'Bob'
      author.email.should == 'bob@mail.com'
      author = Author.find_or_create_from_metadata(metadata)
      author.name.should == 'Bob'
      author.email.should == 'bob@mail.com'
      Author.count.should == 1
    end
  end

  describe '.score' do
    let(:author) { Factory(:author) }
    let(:project_1) { Factory(:project) }
    let(:project_2) { Factory(:project) }

    before do
      project_1.authors << author
      project_2.authors << author

      report_1 = Factory(:report, :project => project_1, :created_at => 2.days.ago)
      report_2 = Factory(:report, :project => project_2, :created_at => 2.days.ago)
      Factory(:problem, :author => author, :report => report_1, :metric => Factory(:metric, :weight => 10))
      Factory(:problem, :author => author, :report => report_2, :metric => Factory(:metric, :weight => 5))

      old_report_1 = Factory(:report, :project => project_1, :created_at => 3.days.ago)
      old_report_2 = Factory(:report, :project => project_2, :created_at => 3.days.ago)
      Factory(:problem, :author => author, :report => old_report_1, :metric => Factory(:metric, :weight => 10))
      Factory(:problem, :author => author, :report => old_report_2, :metric => Factory(:metric, :weight => 5))
    end

    it 'returns the score for a given user for the current state of all his projects' do
      author.score.should == 15
    end
  end
end
