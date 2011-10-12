require 'spec_helper'
require 'rails_best_practices'
require 'lib/rails_best_practices/plugins/reviews/old_school_before_filters_review.rb'

describe RailsBestPractices::Plugins::Reviews::OldSchoolBeforeFiltersReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Plugins::Reviews::OldSchoolBeforeFiltersReview.new) }

  it "should not use badly named methods" do
    content =<<-EOF
    class User
      def do_before_save
        update_counts
      end
    end
    EOF
    runner.review('app/models/user.rb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/models/user.rb:2 - Don't use badly named callbacks"
  end

  it "should use properly named before filters" do
    content =<<-EOF
    class User
      before_save :update_counts
    end
    EOF
    runner.review('app/models/user.rb', content)
    runner.should have(0).errors
  end
end