source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'
gem 'jeweler'

# Database
gem 'sqlite3'

# Assets and forms
gem 'paperclip'
gem 'formtastic', git: 'git://github.com/justinfrench/formtastic.git'

# Asset template engines
gem 'json'
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'
gem 'haml'

gem 'jquery-rails'

group :development, :test do
  gem 'thin'
  gem 'ruby-debug19', require: 'ruby-debug'
  gem 'evergreen', git: 'git://github.com/jnicklas/evergreen.git', submodules: true, require: 'evergreen/rails'
end

group :test do
  gem 'cucumber-rails'
  gem 'capybara-firebug'
  gem 'capybara'
  gem 'database_cleaner'
end
