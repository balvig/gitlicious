FactoryGirl.define do
  factory :problem do
    filename 'model.rb'
    line_number 1
    metric
    after_build { |report| report.stub(:blame) }
  end
end

