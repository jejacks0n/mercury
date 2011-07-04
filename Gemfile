source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'

# Assets and forms
gem 'paperclip'
gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git' # this is only here for the snippet options form

# Asset template engines
gem 'json'
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'

group :development, :test do
  gem 'rocco'
  gem 'uglifier'
  gem 'jquery-rails'
  gem 'jeweler'
  gem 'sqlite3'
  gem 'thin'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'evergreen', :git => 'git://github.com/jnicklas/evergreen.git', :submodules  => true, :require => 'evergreen/rails'
end

group :test do
  gem 'cucumber-rails'
  gem 'capybara-firebug'
  gem 'capybara'
  gem 'database_cleaner'
end
