source 'https://rubygems.org'

gemspec

# dependencies for the dummy app
gem 'rails', '3.2.8'
gem 'jquery-rails'
gem 'sqlite3'
gem 'teabag', '0.3.2'

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
  gem 'sprockets-rails'
end

group :development, :test do
  gem 'rspec-core'
  gem 'cucumber', '~> 1.3.20'
  gem 'cucumber-rails'
  gem 'capybara-firebug'
  gem 'aruba', '0.14.2'
  gem 'database_cleaner'
end

gem 'phantomjs-linux', :git => 'https://github.com/bandzoogle/phantomjs-linux.git'
# if RUBY_PLATFORM =~ /linux/
#   gem 'phantomjs-linux'
# end
