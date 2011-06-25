#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require File.expand_path('../config/application', __FILE__)

Mercury::Application.load_tasks

#
# Cucumber tasks
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

#
# Jeweler tasks
#
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
  [
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

#
# Mercury build tasks
#
namespace :mercury do
  desc "Builds Mercury into the distro ready package"
  task :build => ['build:dialogs', 'build:javascripts', 'build:stylesheets'] do
  end

  namespace :build do

    desc "Combines all dialog and model views into a js file"
    task :dialogs => :environment do
      input = Rails.root.join('app/views')
      File.open(Rails.root.join('public/mercury_distro/javascripts/mercury_dialogs.js'), 'w') do |file|
        %w[modals palettes panels selects].each do |path|
          file.write "// -- #{path.upcase} --\n"
          Dir[input.join('mercury', path, '*.html')].sort.each do |filename|
            file.write %Q{Mercury.preloadedViews['#{filename.gsub(input.to_s, '').gsub(/\.html$/, '')}'] = "}
            File.foreach(filename) { |line| file.write line.chomp.gsub('"', '\\"') }
            file.write %Q{";\n}
          end
        end
      end
    end

    desc "Combine javascripts into mercury.js and mercury.min.js"
    task :javascripts => :environment do
      require 'action_view/helpers/asset_tag_helpers/asset_paths.rb'
      Sprockets::Helpers::RailsHelper
      Rails.application.assets.precompile('mercury.js')
      Dir[Rails.root.join('public/assets/mercury-*.js')].each do |filename|
        copy_file(filename, Rails.root.join('public/mercury_distro/javascripts/mercury.js'))
        remove(filename)
      end

      minified = Uglifier.compile(File.read(Rails.root.join('public/mercury_distro/javascripts/mercury.js')))
      File.open(Rails.root.join('public/mercury_distro/javascripts/mercury.min.js'), 'w') do |file|
        file.write(minified)
      end
    end

    desc "Combine stylesheets into mercury.css and mercury.bundle.css (bundling images where possible)"
    task :stylesheets => :environment do
      require 'base64'
      require 'action_view/helpers/asset_tag_helpers/asset_paths.rb'
      Sprockets::Helpers::RailsHelper
      Rails.application.assets.precompile('mercury.css')

      Dir[Rails.root.join('public/assets/mercury-*.css')].each do |filename|
        copy_file(filename, Rails.root.join('public/mercury_distro/stylesheets/mercury.css'))
        remove(filename)
      end

      bundled = File.read(Rails.root.join('public/mercury_distro/stylesheets/mercury.css'))

      # import image files using: url(data:image/gif;base64,XEQA7)
      bundled.gsub!(/url\(\/assets\/(.*?)\)/ix) do |m|
        encoded = Base64.encode64(File.read(Rails.root.join('app/assets/images', $1))).gsub("\n", '')
        "url(data:image/png;base64,#{encoded})"
      end

      # remove comments (only /* */ style)
      bundled.gsub!(/\/\*[^!].*?\*\//m, '')

      # remove whitespace
      bundled.gsub!(/\s+/, ' ')

      # put a few line breaks back in
      bundled.gsub!(/\}/, "}\n")
      bundled.gsub!(/ \*/, "\n *")
      bundled.gsub!(/ \*\//, " */\n")

      File.open(Rails.root.join('public/mercury_distro/stylesheets/mercury.bundle.css'), 'wb') do |file|
        file.write(bundled)
      end
    end

  end
end
