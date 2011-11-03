RSpec.configure do |config|
  config.before(:each) do
    FileUtils.rm_r Dir.glob(Rails.root.join(Rails.application.config.repo_path,'*'))
  end
  config.after(:all) do
    FileUtils.rm_r Dir.glob(Rails.root.join(Rails.application.config.repo_path,'*'))
  end

end
