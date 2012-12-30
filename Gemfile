source 'http://rubygems.org'

gemspec

#Dependencies for the dummy app
gem 'rails', '3.2.8'
gem 'jquery-rails'
gem 'sqlite3'

gem 'teabag', '>= 0.4.5'
# required for travis-ci and linux environments
gem "phantomjs-linux" if RUBY_PLATFORM =~ /linux/

group :assets do
  gem 'sass-rails', "~> 3.2.5"
  gem 'uglifier', "~> 1.3.0"
  gem 'sprockets-rails', '~> 0.0.1'
end
