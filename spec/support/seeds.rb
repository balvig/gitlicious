RSpec.configure do |config|
  config.before(:each) do
    require Rails.root.join('db','seeds')
  end
end