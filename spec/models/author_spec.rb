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
end
