FactoryGirl.define do
  factory :problem do
    description 'This should be fixed'
    filename 'model.rb'
    line_number
    metric
    author
    after_build { |report| report.stub(:blame) }
  end

  sequence :line_number do |n|
    n
  end
end

