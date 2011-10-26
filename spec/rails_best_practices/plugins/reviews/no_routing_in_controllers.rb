require 'spec_helper'
require 'rails_best_practices'
require 'lib/rails_best_practices/plugins/reviews/no_routing_in_controllers_review.rb'

FILE_NAME= "app/controllers/posts_controller.rb"

describe RailsBestPractices::Plugins::Reviews::NoRoutingInControllersReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Plugins::Reviews::NoRoutingInControllersReview.new) }

  it "should raise error when we use a flag to distinguish get/post state " do
    content =<<-EOF
    class Contact
      def inquiry
        redirect_to(new_support_request_url) and return if params[:id].blank?
        @category = InquiryCategory.find(params[:id])

        if params[:submit_flag]
          @error = true unless(params[:email][/.@.+\..+/])
        end
      end
    end

    EOF
        runner.review(FILE_NAME, content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "#{FILE_NAME}:6 - No routing inside controllers"

  end
  it "should raise errors when we call not allowed methods of the request object " do
    content =<<-EOF
     class PostsController < ApplicationController
       def publish
         if request.post?
           if params[:new]
           end
         end
       end
      end
       EOF
    runner.review(FILE_NAME, content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "#{FILE_NAME}:3 - No routing inside controllers"
  end

  it "should not raise errors when we call allowed methods of the request object" do
    content =<<-EOF
     class PostsController < ApplicationController
       def publish
           session[:return_to] = request.path

           if params[:new]
           end
       end
      end
    EOF
    runner.review(FILE_NAME, content)
    runner.should have(0).errors
  end

  it "should not raise errors when we dont route in controllers" do
    content =<<-EOF
     class PostsController < ApplicationController
       def publish
           if params[:new]
           end
       end
      end
    EOF
    runner.review(FILE_NAME, content)
    runner.should have(0).errors
  end
end
