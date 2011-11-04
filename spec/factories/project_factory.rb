FactoryGirl.define do
  factory :real_project, :class => :project do
    repo_url 'git://github.com/balvig/gitlicious_dummy.git'
  end

  factory :project, :parent => :real_project do
    after_build { |project| project.stub(:clone_repository) }
  end

  factory :project_with_no_metrics, :parent => :real_project do
    after_build { |project| project.stub(:create_default_metrics) }
  end
end
