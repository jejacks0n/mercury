source 'http://rubygems.org'

gemspec

# dependencies for the dummy app
gem 'rails', '>= 3.2.8'
gem 'jquery-rails'
gem 'sqlite3'
gem 'teabag'

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
  gem 'sprockets-rails'
  gem 'therubyracer', platforms: :ruby
end

group :development, :test do
  gem 'rspec-core'
  gem 'cucumber-rails'
  gem 'capybara-firebug'
  gem 'aruba'
  gem 'database_cleaner'

  # required for travis-ci and linux environments
  gem "phantomjs-linux" if  RUBY_PLATFORM =~ /linux/
end


