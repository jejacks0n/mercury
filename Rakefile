#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'
require 'evergreen/tasks'

Cucumber::Rake::Task.new(:cucumber) do |t|
  # t.cucumber_opts = "features --format pretty"
end

task :default => ['spec:javascripts', :cucumber]

#
# Mercury build tasks
#
namespace :mercury do
  require 'uglifier'
  require 'sprockets-rails'

  desc "Builds Mercury into the distribution ready package"
  task :build => ['build:dialogs', 'build:javascripts', 'build:stylesheets']

  namespace :build do

    desc "Combines all dialog and model views into a js file"
    task :dialogs => :environment do
      input = Mercury::Engine.root.join('app/views')
      File.open(Mercury::Engine.root.join('distro/javascripts/mercury_dialogs.js'), 'w') do |file|
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
      env    = Rails.application.assets
      target = Pathname.new(File.join(Mercury::Engine.root.join('distro'), 'build'))
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

      Dir[Mercury::Engine.root.join('distro/build/mercury-*.js')].each do |filename|
        copy_file(filename, Mercury::Engine.root.join('distro/javascripts/mercury.js'))
        copy_file(filename, Mercury::Engine.root.join('app/assets/javascripts/mercury/mercury-compiled.js'))
        remove(filename)
      end

      Dir[Mercury::Engine.root.join('distro/build/mercury/mercury-*.js')].each do |filename|
        copy_file(filename, Mercury::Engine.root.join('distro/javascripts/mercury.min.js'))
        remove(filename)
        minified = '' #Uglifier.compile(File.read(Mercury::Engine.root.join('app/assets/javascripts/mercury/dependencies/jquery-1.7.js')))
        minified += Uglifier.compile(File.read(Mercury::Engine.root.join('distro/javascripts/mercury.min.js')))
        File.open(Mercury::Engine.root.join('distro/javascripts/mercury.min.js'), 'w') do |file|
          file.write(File.read(Mercury::Engine.root.join('app/assets/javascripts/mercury.js')))
          file.write(minified)
        end
      end

      #copy_file(Mercury::Engine.root.join('app/assets/javascripts/mercury_loader.js'), Mercury::Engine.root.join('distro/javascripts/mercury_loader.js'))
    end

    desc "Combine stylesheets into mercury.css and mercury.bundle.css (bundling images where possible)"
    task :stylesheets => :environment do
      env    = Rails.application.assets
      target = Pathname.new(File.join(Mercury::Engine.root.join('distro'), 'build'))
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

      Dir[Mercury::Engine.root.join('distro/build/mercury-*.css')].each do |filename|
        copy_file(filename, Mercury::Engine.root.join('distro/stylesheets/mercury.css'))
        remove(filename)
      end

      bundled = File.read(Mercury::Engine.root.join('distro/stylesheets/mercury.css'))

      # import image files using: url(data:image/gif;base64,XEQA7)
      bundled.gsub!(/url\(\/assets\/(.*?)\)/ix) do |m|
        encoded = Base64.encode64(File.read(Mercury::Engine.root.join('app/assets/images', $1))).gsub("\n", '')
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

      File.open(Mercury::Engine.root.join('distro/stylesheets/mercury.bundle.css'), 'wb') do |file|
        file.write(bundled)
      end
    end

  end
end


