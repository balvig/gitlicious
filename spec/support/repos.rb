RSpec.configure do |config|
  config.before(:each) do
    FileUtils.rm_r Dir.glob(Rails.root.join('repos','*'))
  end
end