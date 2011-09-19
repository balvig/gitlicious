Factory.define :rbp_metric, :class => :metric do |f|
  f.name                'rails_best_practices'
  f.weight              0.5
  f.command             'rails_best_practices --without-color .'
  f.score_pattern       'Found (\d+) error'
  f.line_number_pattern '^.+:(\d+)'
  f.filename_pattern    '^\.\/(.+):\d'
  f.description_pattern '\s-\s(.+)$'
end

Factory.define :cleanup_metric, :class => :metric do |f|
  f.name                'cleanup'
  f.weight              5
  f.command             "grep -r -n '#CLEANUP:' app/controllers app/helpers app/models lib"
  f.line_number_pattern '^.+:(\d+)'
  f.filename_pattern    '^(.+):\d'
  f.description_pattern '#CLEANUP:\s(.+)$'
end