require ::File.expand_path('../application',  __FILE__)

Evergreen.configure do |config|
end

# To provide fixtures for real requests and responses we add in our own custom
# response path.
module Evergreen

  class << self
    def application_with_additions(suite)
      app = application_without_additions(suite)

      app.map "/evergreen/responses" do
        use Rack::Static, :urls => ["/"], :root => File.join(suite.root, '/spec/javascripts/responses')
        run lambda { |env| [404, {}, "No such file"]}
      end

      app.map "/responses" do
        use Rack::Static, :urls => ["/"], :root => File.join(suite.root, '/spec/javascripts/responses')
        run lambda { |env| [404, {}, "No such file"]}
      end

      app.map "/assets" do
        assets = Rails.application.config.assets
        if assets.enabled
          paths = %W{app/assets/javascripts lib/assets/javascripts vendor/assets/javascripts}.map{ |p| File.join(suite.root, p) }

          require 'sprockets'

          sprockets = Sprockets::Environment.new(suite.root) do |env|
            paths.each { |path| env.append_path(path) }
            env.js_compressor = nil
          end

          run sprockets
        end
      end
      app
    end

    alias_method :application_without_additions, :application
    alias_method :application, :application_with_additions
  end

end

# The following allows us to have a nested directory structure of specs.  With
# a lot of specs this is needed.
module Evergreen
  class Suite
    def specs
      Dir.glob(File.join(root, Evergreen.spec_dir, '**', '*_spec.{js,coffee,js.coffee}')).map do |path|
        Spec.new(self, path.gsub(File.join(root), ''))
      end
    end

    def templates
      Dir.glob(File.join(root, Evergreen.template_dir, '**', '*')).map do |path|
        Template.new(self, path.gsub(File.join(root), '')) unless File.directory?(path)
      end.compact
    end
  end
end

module Evergreen
  class Spec
    def initialize(suite, name)
      @suite = suite
      @name = name
      @name = "#{Evergreen.spec_dir}/#{name}" if !exist?
    end

    def name
      @name.gsub("/#{Evergreen.spec_dir}/", '')
    end

    def read
      require 'coffee-script'
      if full_path =~ /\.coffee$/
        CoffeeScript.compile File.read(full_path), :bare => true
      else
        File.read(full_path)
      end
    end
  end
end

module Evergreen
  class Template
    def name
      @name.gsub("/#{Evergreen.template_dir}/", '')
    end

    def full_path
      File.join(root, @name)
    end
  end
end
