source 'http://rubygems.org'

gem 'rails', '3.1.0.beta1'

gem 'mysql2'
gem 'sass'
gem 'coffee-script'
gem 'uglifier'
gem 'haml'
gem 'haml-rails'

gem 'paperclip', git: 'git://github.com/thoughtbot/paperclip.git'
gem 'formtastic', git: 'git://github.com/justinfrench/formtastic.git'

gem 'eventmachine', :git => 'git://github.com/eventmachine/eventmachine.git'
gem 'em-hiredis'
gem 'em-websocket'

group :development do
end

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
