FactoryGirl.define do
  factory :problem do
    filename 'model.rb'
    line_number
    metric
    after_build { |report| report.stub(:blame) }
  end

  sequence :line_number do |n|
    n
  end
end

