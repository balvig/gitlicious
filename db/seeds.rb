Metric::DEFAULTS.each do |name, attributes|
  Metric.create!(attributes)
end
