FactoryGirl.define do
  factory :real_project, :class => :project do
    repo_url 'git://github.com/balvig/gitlicious_dummy.git'
  end

  factory :project, :parent => :real_project do
    after_build { |project| project.stub(:clone_repository) }
  end

end
