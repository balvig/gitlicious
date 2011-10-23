require 'spec_helper'
require 'rails_best_practices'
require 'lib/rails_best_practices/plugins/reviews/no_inline_styling_review.rb'


describe RailsBestPractices::Plugins::Reviews::NoInlineStylingReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Plugins::Reviews::NoInlineStylingReview.new) }


  it "should not use inline styling in haml views" do
    #careful with haml indent, if the haml file is not valid rbp will just
    #silently ignore it
    content =<<-EOF
.content
  .title This is a graph
  #graph_wrapper{:style => "overflow:hidden;"}
    = render 'shared/graph', :all => params[:all]
    .subtitle{:style => "font-size:90%;"}
    EOF

    runner.review('app/views/posts/index.html.haml', content)
    runner.should have(2).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.haml:1 - No inline styles in views"
  end

  it "should not raise error for .haml views without inlines" do
    content =<<-EOF
.content
  .title This is a graph
  #graph_wrapper
    = render 'shared/graph', :all => params[:all]
    .subtitle
    EOF
    runner.review('app/views/posts/index.html.haml', content)
    runner.should have(0).errors
  end


  it "should not use inline styling in views" do
 content =<<-EOF
  <div id="page">
    <div id="graph" style='height:350px'></div>
  </div>
EOF
    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/views/posts/index.html.erb:1 - No inline styles in views"
  end

  it "should not raise errors for views without inline styling" do
    content =<<-EOF
      <div id="graph"></div>
    EOF
    runner.review('app/views/posts/index.html.erb', content)
    runner.should have(0).errors
  end
end
