require 'spec_helper'
require 'rails_best_practices'
require 'lib/rails_best_practices/plugins/reviews/no_find_in_views_review.rb'


describe RailsBestPractices::Plugins::Reviews::NoFindInViewsReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Plugins::Reviews::NoFindInViewsReview.new) }

  ERROR_MESSAGE= "No model finds in views"

  it "should give an error when we use simple find" do

    content =<<-EOF
     <div id="content">
       <h3 class="content_title">
         <%= image_tag('image_file.png') %>
         My content here
       </h3>
       <% User.find(10) %>
    EOF

    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.erb:1 - #{ERROR_MESSAGE}"
  end

  it "should give an error when we use complex find" do
    content =<<-EOF
     <div id="content">
       <h3 class="content_title">
         <%= image_tag('image_file.png') %>
         My content here
       </h3>
          sorry, not possible
          <% User.find_by_zip(@zip) %>
    EOF

    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.erb:1 - #{ERROR_MESSAGE}"
  end

  it "should give an error when we use find in conditionals " do
    content =<<-EOF
     <div id="content">
       <h3 class="content_title">
         <%= image_tag('image_file.png') %>
         My content here
       </h3>
         <% unless User.find(@login_user.id).available? -%>
          sorry, not possible
        <% end %>
    EOF

    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.erb:1 - #{ERROR_MESSAGE}"
  end

  it "should give an error when using all" do
    content =<<-EOF
     <div id="content">
       <h3 class="content_title">
         <%= image_tag('image_file.png') %>
         My content here
       </h3>
          <% User.all %>
    EOF

    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.erb:1 - #{ERROR_MESSAGE}"

  end

  it "should give an error when using first" do
    content =<<-EOF
     <div id="content">
       <h3 class="content_title">
         <%= image_tag('image_file.png') %>
         My content here
       </h3>
          <% User.first %>
    EOF

    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.erb:1 - #{ERROR_MESSAGE}"

  end

  it "should give an error when using last" do
    content =<<-EOF
     <div id="content">
       <h3 class="content_title">
         <%= image_tag('image_file.png') %>
         My content here
       </h3>
          <% User.last %>
    EOF

    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.erb:1 - #{ERROR_MESSAGE}"

  end

  it "should not raise error for views without finds" do
    content =<<-EOF
     <div id="content">
       <h3 class="content_title">
         <%= image_tag('image_file.png') %>
         My content here
       </h3>
    EOF
    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(0).errors
  end

end

