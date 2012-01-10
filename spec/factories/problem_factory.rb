FactoryGirl.define do
  factory :problem do
    description 'This should be fixed'
    filename 'model.rb'
    line_number
    metric
    author
    report
    after_build { |problem| problem.stub(:blame) }
  end

  sequence :line_number do |n|
    n
  end
end

