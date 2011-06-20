#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Mercury::Application.load_tasks

#
# Cucumber
#
unless ARGV.any? {|a| a =~ /^gems/} # Don't load anything when running the gems:* tasks

vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
$LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?

begin
  require 'cucumber/rake/task'

  namespace :cucumber do
    Cucumber::Rake::Task.new({:ok => 'db:test:prepare'}, 'Run features that should pass') do |t|
      t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'default'
    end

    Cucumber::Rake::Task.new({:wip => 'db:test:prepare'}, 'Run features that are being worked on') do |t|
      t.binary = vendored_cucumber_bin
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'wip'
    end

    Cucumber::Rake::Task.new({:rerun => 'db:test:prepare'}, 'Record failing features and run only them if any exist') do |t|
      t.binary = vendored_cucumber_bin
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'rerun'
    end

    desc 'Run all features'
    task :all => [:ok, :wip]
  end
  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'

  task :default => :cucumber

  task :features => :cucumber do
    STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
  end

  # In case we don't have ActiveRecord, append a no-op task that we can depend upon.
  task 'db:test:prepare' do
  end
rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

end


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
