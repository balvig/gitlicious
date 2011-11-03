FactoryGirl.define do
  factory :project do
    repo_url 'git://github.com/balvig/gitlicious_dummy.git'
  end

  factory :empty_project, :parent => :project do
    after_build { |project| project.stub(:create_default_metrics) }
  end
end
