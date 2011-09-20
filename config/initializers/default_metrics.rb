yaml = File.read(Rails.root.join('config','default_metrics.yml'))
Rails.application.config.default_metrics = YAML.load(yaml).symbolize_keys