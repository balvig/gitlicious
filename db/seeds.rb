Metric.create!( :name                 => 'rails_best_practices',
                :weight               => 0.5,
                :command              => 'rails_best_practices --without-color .',
                :score_pattern        => 'Found (\d+) error',
                :line_number_pattern  => '^.+:(\d+)',
                :filename_pattern     => '^\.\/(.+):\d',
                :description_pattern  => '\s-\s(.+)$'
              )

Metric.create!( :name                 => 'cleanup',
                :weight               => 5,
                :command              => "grep -r -n '#CLEANUP:' app/controllers app/helpers app/models lib",
                :line_number_pattern  => '^.+:(\d+)',
                :filename_pattern     => '^(.+):\d',
                :description_pattern  => '#CLEANUP:\s(.+)$'
              )

Metric.create!( :name                 => 'flog',
                :command              => 'flog -s --continue app/controllers app/helpers app/models lib',
                :score_pattern        => '([\d\.]+): flog\/method average'
              )

Metric.create!( :name                 => 'rcov',
                :weight               => 2,
                :command              => "bundle exec rcov -Ispec:lib --gcc --rails --exclude osx\/objc,gems\/,spec\/,features\/,seeds\/ --include views -Ispec ./spec/**/*.rb  --only-uncovered --no-html",
                :line_number_pattern  => '^.+:(\d+)',
                :filename_pattern     => '^(.+):\d',
                :description_pattern  => ':\d+:(.+)$'
              )

# bundle exec rcov -Ispec:lib --gcc --rails --exclude osx\/objc,gems\/,spec\/,features\/,seeds\/ --include views -Ispec ./spec/models/*.rb  ./spec/helpers/*.rb ./spec/requests/*.rb ./spec/requests/*.rb --only-uncovered --no-html

git log --all --format='%aN <%cE>' | sort -u