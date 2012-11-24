module Mercury
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root Mercury::Engine.root

      desc "Installs Mercury into your application by copying the configuration file."

      class_option :full, :type => :boolean, :aliases => '-g',
                   :desc => 'Full installation will install the layout and css files for easier customization.'

      class_option :haml, :type => :boolean,
                   :desc => 'Use a Haml layout template (instead of ERB)'

      def copy_config
        copy_file 'app/assets/javascripts/mercury.js'
      end

      def add_routes
        route %Q{mount Mercury::Engine => '/'}
      end

      def copy_layout_and_css_overrides
        if options[:full] || yes?("Install the layout file and CSS? [yN]")
          layout_ext = (options[:haml]) ? 'haml' : 'erb'
          copy_file "app/views/layouts/mercury.html.#{layout_ext}"
          copy_file 'app/assets/stylesheets/mercury.css'
        end
      end

      def display_readme
        readme 'POST_INSTALL' if behavior == :invoke
      end

    end
  end
end
