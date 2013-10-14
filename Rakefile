#!/usr/bin/env rake
load File.expand_path('../config.ru', __FILE__)

Mercury::Application.load_tasks

desc "Builds assets into the distribution ready bundle"
task :build => ['build:javascripts', 'build:stylesheets', 'build:fonts', 'build:assets'] do
  puts 'Done building'
end

namespace :build do
  env          = Rails.application.assets
  output_path  = Rails.root.join('distro')
  asset_paths  = ['fonts/*']
  fontcustom   = ['mercury-icons.yml']
  stylesheets  = ['mercury.css', 'mercury_regions.css']
  javascripts  = {
    dependencies: 'mercury/dependencies.js',
    locales:      'mercury/locales.js',
    regions:      'mercury/regions.js',
    base:         'mercury/mercury.js',
    config:       'mercury/config.js'
  }

  desc "Compile coffeescripts into javascripts"
  task :javascripts => :environment do
    puts 'Building javascripts...'

    config = env.find_asset(javascripts[:config])
    base = env.find_asset(javascripts[:base])

    FileUtils.mkdir_p(output_path)

    # base javascripts and configuration
    puts "  base: mercury.js"
    File.open(output_path.join('mercury.js'), 'w') do |file|
      file.write(config.source)
      file.write(base.source)
    end

    # minified base javascripts and not minified configuration
    puts "  base: mercury.min.js"
    File.open(output_path.join('mercury.min.js'), 'w') do |file|
      file.write(config.source)
      file.write(Uglifier.compile(base.source, squeeze: true))
    end

    # write dependencies
    env.find_asset(javascripts[:dependencies]).send(:required_assets).each do |asset|
      filename = File.basename(asset.logical_path)
      next if filename == 'dependencies.js'
      puts "  dependency: #{filename}"

      asset.write_to(output_path.join('dependencies', filename))
    end

    # write locales
    env.find_asset(javascripts[:locales]).send(:required_assets).each do |asset|
      filename = File.basename(asset.logical_path)
      next if filename == 'locales.js'
      puts "  locale: #{filename}"

      asset.write_to(output_path.join('locales', filename))
    end

    # write regions
    regions = []
    env.find_asset(javascripts[:regions]).send(:required_assets).each do |asset|
      filename = File.basename(asset.logical_path)
      next if filename == 'regions.js'
      next unless asset.logical_path =~ /^mercury/
      puts "  region: #{filename}"
      regions << asset

      Rails.application.config.assets.debug = false
      asset = env.find_asset(asset.logical_path)
      asset.write_to(output_path.join('regions', filename))
      Rails.application.config.assets.debug = true

      File.open(output_path.join('regions', filename.gsub(/\.js$/, '.min.js')), 'w') do |file|
        file.write(Uglifier.compile(asset.source, squeeze: true))
      end
    end

    # bundled javascript (base, config, and regions without dependencies)
    #puts "  base: mercury.bundle.js"
    #File.open(output_path.join('mercury.bundle.js'), 'w') do |file|
    #  file.write(config.source)
    #  file.write(base.source)
    #  for region in regions
    #    file.write(region.source)
    #  end
    #end
  end

  desc "Compile sass files into css"
  task :stylesheets => :environment do
    puts 'Building stylesheets...'

    stylesheets.each do |path|
      puts "  base: #{path}"
      asset = env.find_asset(path)
      asset.write_to(output_path.join(path))

      # add base64 encoded image/font urls
      processed = asset.source.gsub(/url\(\/assets\/mercury\/(.*?)\)/ix) do |m|
        format = 'image/png'
        file = Rails.root.join('lib/images/mercury', $1)
        unless File.exists?(file)
          format = 'font/ttf'
          file = Rails.root.join('lib/fonts/mercury', $1)
        end
        encoded = Base64.encode64(File.read(file)).gsub("\n", '')
        "url(data:#{format};base64,#{encoded})"
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

  desc "Build svg images into fonts"
  task :fonts => :environment do
    puts 'Building fonts...'

    fontcustom.each do |config|
      puts "  fontcustom: #{config}"
      `fontcustom compile --config lib/fonts/glyphs/#{config}`
    end
  end

  desc "Copy asset files into distro"
  task :assets => :environment do
    puts 'Copying assets...'

    FileUtils.mkdir_p(output_path.join('assets'))
    for path in asset_paths
      for file in Dir[Rails.root.join('lib', path)]
        puts "  #{File.directory?(file) ? 'path' : 'file'}: #{File.basename(file)}"
        FileUtils.cp_r file, output_path.join('assets')
      end
    end
  end
end

task :default => [:teaspoon, 'build']
