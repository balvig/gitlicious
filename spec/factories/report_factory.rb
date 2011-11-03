FactoryGirl.define do
  factory :report do
    sha
    after_build do |report|
      report.stub(:run_metrics)
      report.stub(:set_sha)
    end
  end

  sequence :sha do |n|
    n
  end
end
