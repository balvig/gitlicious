# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Metric.create!( :name                 => 'rails_best_practices',
                :command              => 'rails_best_practices --without-color',
                :score_pattern        => 'Found (\d+) error',
                :line_number_pattern  => ':(\d+)',
                :filename_pattern     => '^(.+):\d',
                :description_pattern  => '\s-\s(.+)$'
              )

Metric.create!( :name                 => 'cleanup',
                :command              => 'grep -r -n "#CLEANUP:"',
                :score_pattern        => nil,
                :line_number_pattern  => ':(\d+)',
                :filename_pattern     => '^(.+):\d',
                :description_pattern  => '#CLEANUP:\s(.+)$'
              )

Metric.create!( :name                 => 'flog',
                :command              => 'flog -s --continue',
                :score_pattern        => '([\d\.]+): flog\/method average',
                :line_number_pattern  => nil,
                :filename_pattern     => nil,
                :description_pattern  => nil
              )