require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mercury-rails"
  gem.homepage = "http://github.com/jejacks0n/mercury"
  gem.license = "MIT"
  gem.summary = %Q{A fully featured and advanced HTML5 WYSIWYG editor written in CoffeeScript on top of Rails 3.1}
  gem.description = %Q{A fully featured and advanced HTML5 WYSIWYG editor written in CoffeeScript on top of Rails 3.1}
  gem.email = "jejacks0n@gmail.com"
  gem.authors = ["Jeremy Jackson"]
  # dependencies defined in Gemfile
  ['app/controllers/application_controller.rb',
   'app/views/application/*',
   'app/views/layouts/application.html.haml',
   'config/environments/*',
   'config/initializers/*',
   'config/application.rb',
   'config/boot.rb',
   'config/cucumber.yml',
   'config/database.yml',
   'config/environment.rb',
   'config/evergreen.rb',
   'db/*.sqlite3',
   'db/schema.rb',
   'lib/tasks/*',
   'public/*',
   'script/*',
   'log/*',
   '.gitignore',
   '.pairs',
   '.rvmrc',
   'config.ru',
   'Gemfile',
   'Gemfile.lock',
   'Rakefile',
   ].each do |file_or_dir|
    gem.files.exclude file_or_dir
  end
end
Jeweler::RubygemsDotOrgTasks.new