#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

begin
  require 'bundler/gem_tasks'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require File.expand_path('../config/application', __FILE__)

Mercury::Application.load_tasks

#
# Mercury build tasks
#
namespace :mercury do

  desc "Builds the documentation using docco"
  task :document do
    require 'rocco'
    output_dir = Rails.root.join('annotated_source').to_s
    sources = Dir[Rails.root.join('vendor/assets/javascripts/*.js').to_s]
    sources += Dir[Rails.root.join('vendor/assets/javascripts/**/*.coffee').to_s]
    sources.each do |filename|
      rocco = Rocco.new(filename, sources, {:template_file => Rails.root.join('annotated_source.template'), :docblocks => true})
      dest = File.join(output_dir, filename.sub(Regexp.new("^#{Rails.root.join('vendor/assets/javascripts')}"), '').sub(Regexp.new("#{File.extname(filename)}$"),".html"))
      puts "rocco: #{filename} -> #{dest}"
      FileUtils.mkdir_p File.dirname(dest)
      File.open(dest, 'wb') { |fd| fd.write(rocco.to_html) }
    end
  end

  desc "Builds Mercury into the distribution ready package"
  task :build => ['build:dialogs', 'build:javascripts', 'build:stylesheets']

  namespace :build do

    desc "Combines all dialog and model views into a js file"
    task :dialogs => :environment do
      input = Rails.root.join('app/views')
      File.open(Rails.root.join('public/mercury/javascripts/mercury_dialogs.js'), 'w') do |file|
        file.write "if (!window.Mercury) window.Mercury = {preloadedViews: {}};\n"
        %w[lightviews modals palettes panels selects].each do |path|
          file.write "// -- #{path.upcase} --\n"
          Dir[input.join('mercury', path, '*.html')].sort.each do |filename|
            file.write %Q{Mercury.preloadedViews['#{filename.gsub(input.to_s, '')}'] = "}
            File.foreach(filename) { |line| file.write line.chomp.gsub('"', '\\"') }
            file.write %Q{";\n}
          end
        end
      end
    end

    desc "Combine javascripts into mercury.js and mercury.min.js"
    task :javascripts => :environment do
      config = Rails.application.config
      env    = Rails.application.assets
      target = Pathname.new(File.join(Rails.public_path, config.assets.prefix))
      manifest = {}

      ['mercury.js', 'mercury/mercury.js'].each do |path|
        env.each_logical_path do |logical_path|
          if path.is_a?(Regexp)
            next unless path.match(logical_path)
          else
            next unless File.fnmatch(path.to_s, logical_path)
          end

          if asset = env.find_asset(logical_path)
            manifest[logical_path] = asset.digest_path
            filename = target.join(asset.digest_path)
            mkdir_p filename.dirname
            asset.write_to(filename)
          end
        end
      end

      Dir[Rails.root.join('public/assets/mercury-*.js')].each do |filename|
        copy_file(filename, Rails.root.join('public/mercury/javascripts/mercury.js'))
        remove(filename)
      end

      Dir[Rails.root.join('public/assets/mercury/mercury-*.js')].each do |filename|
        copy_file(filename, Rails.root.join('public/mercury/javascripts/mercury.min.js'))
        remove(filename)
        minified = Uglifier.compile(File.read(Rails.root.join('vendor/assets/javascripts/mercury/dependencies/jquery-1.7.js')))
        minified += Uglifier.compile(File.read(Rails.root.join('public/mercury/javascripts/mercury.min.js')))
        File.open(Rails.root.join('public/mercury/javascripts/mercury.min.js'), 'w') do |file|
          file.write(File.read(Rails.root.join('vendor/assets/javascripts/mercury.js')))
          file.write(minified)
        end
      end

      copy_file(Rails.root.join('vendor/assets/javascripts/mercury_loader.js'), Rails.root.join('public/mercury/javascripts/mercury_loader.js'))
    end

    desc "Combine stylesheets into mercury.css and mercury.bundle.css (bundling images where possible)"
    task :stylesheets => :environment do
      config = Rails.application.config
      env    = Rails.application.assets
      target = Pathname.new(File.join(Rails.public_path, config.assets.prefix))
      manifest = {}

      ['mercury.css'].each do |path|
        env.each_logical_path do |logical_path|
          if path.is_a?(Regexp)
            next unless path.match(logical_path)
          else
            next unless File.fnmatch(path.to_s, logical_path)
          end

          if asset = env.find_asset(logical_path)
            manifest[logical_path] = asset.digest_path
            filename = target.join(asset.digest_path)
            mkdir_p filename.dirname
            asset.write_to(filename)
          end
        end
      end

      Dir[Rails.root.join('public/assets/mercury-*.css')].each do |filename|
        copy_file(filename, Rails.root.join('public/mercury/stylesheets/mercury.css'))
        remove(filename)
      end

      bundled = File.read(Rails.root.join('public/mercury/stylesheets/mercury.css'))

      # import image files using: url(data:image/gif;base64,XEQA7)
      bundled.gsub!(/url\(\/assets\/(.*?)\)/ix) do |m|
        encoded = Base64.encode64(File.read(Rails.root.join('vendor/assets/images', $1))).gsub("\n", '')
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

      File.open(Rails.root.join('public/mercury/stylesheets/mercury.bundle.css'), 'wb') do |file|
        file.write(bundled)
      end
    end

  end
end

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
