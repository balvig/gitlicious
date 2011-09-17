RSpec.configure do |config|
  config.before(:all) do
    require Rails.root.join('db','seeds')
  end
  
  config.after(:all) do
    Metric.delete_all
  end
end