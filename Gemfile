source 'http://rubygems.org'

gem 'rails', '~>3.0.10'
gem 'simple_form'
gem 'git'
gem 'rails_best_practices', :git => 'git://github.com/balvig/rails_best_practices.git'
gem 'reek'
gem 'haml'
gem 'airbrake'
gem 'yaml_db'
gem 'whenever', :require => false

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'timecop'
  gem 'watchr'
end

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'pry'
  gem 'simplecov', :require => false
end

group :production do
  gem 'mysql2', '<0.3'
end
