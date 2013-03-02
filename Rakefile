#!/usr/bin/env rake
load File.expand_path('../config.ru', __FILE__)

Mercury::Application.load_tasks

namespace :mercury do
  desc "Builds assets into the distribution ready bundle"
  task :build => ['build:javascripts', 'build:stylesheets'] do
    puts 'Done building'
  end

  namespace :build do
    env          = Rails.application.assets
    output_path  = Rails.root.join('distro')
    stylesheets  = ['mercury.css']
    javascripts  = {
      dependencies: 'mercury/dependencies.js',
      regions:      'mercury/regions.js',
      config:       'mercury/config.js',
      base:         'mercury/mercury.js',
      other:        []
    }

    desc "Compile coffeescripts into javascripts"
    task :javascripts => :environment do
      puts 'Building javascripts...'

      path = javascripts[:base]
      config = env.find_asset(javascripts[:config])
      base = env.find_asset(javascripts[:base])
      dependencies = env.find_asset(javascripts[:dependencies])

      # write dependencies
      dependencies.send(:required_assets).each do |asset|
        filename = File.basename(asset.logical_path)
        next if filename == 'dependencies.js'
        asset.write_to(output_path.join('dependencies', filename))
      end

      # compile locale files
      Dir.glob(Rails.root.join('lib/javascripts/mercury/locales/*.locale.coffee')) do |file|
        asset = env.find_asset(file)
        asset.write_to(output_path.join('locales', File.basename(file).gsub(/\.coffee$/, '.js')))
      end

      # base javascripts and configuration
      File.open(output_path.join('mercury.js'), 'w') do |file|
        file.write(config.source)
        file.write(base.source)
      end

      # minified base javascripts and not minified configuration
      File.open(output_path.join('mercury.min.js'), 'w') do |file|
        file.write(config.source)
        file.write(Uglifier.compile(base.source, squeeze: true))
      end

      # write region types
      env.find_asset(javascripts[:regions]).send(:required_assets).each do |asset|
        filename = File.basename(asset.logical_path)
        next if filename == 'regions.js'
        asset.write_to(output_path.join('regions', filename))
        File.open(output_path.join('regions', filename.gsub(/\.js$/, '.min.js')), 'w') do |file|
          file.write(Uglifier.compile(asset.source, squeeze: true))
        end
      end

      # compile other javascripts
      javascripts[:other].each do |path|
        asset = env.find_asset(path)
        asset.write_to(output_path.join(path))

        File.open(output_path.join(path.gsub('.js', '.min.js')), 'w') do |file|
          file.write(Uglifier.compile(asset.source, squeeze: true))
        end
      end
    end

    desc "Compile sass files into css"
    task :stylesheets => :environment do
      puts 'Building stylesheets...'
      stylesheets.each do |path|
        asset = env.find_asset(path)
        asset.write_to(output_path.join(path))

        # add base64 encoded image urls
        processed = asset.source.gsub(/url\(\/assets\/mercury\/(.*?)\)/ix) do |m|
          encoded = Base64.encode64(File.read(Rails.root.join('lib/images/mercury', $1))).gsub("\n", '')
          "url(data:image/png;base64,#{encoded})"
        end

        # minimized css with a few line breaks added in
        minified = YUI::CssCompressor.new.compress(processed).gsub!(/\}/, "}\n")
        minified.gsub!("}\nfrom", '}from')
        minified.gsub!("}\n}", '}}')
        minified.gsub!('*/', "*/\n")
        File.open(output_path.join(path.gsub('.css', '.bundle.css')), 'w') do |file|
          file.write(minified)
        end
      end
    end
  end
end

task :default => [:teabag, 'mercury:build']
