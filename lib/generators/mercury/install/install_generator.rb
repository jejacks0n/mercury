module Mercury
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root Mercury::Engine.root

      desc "Installs Mercury into your application by copying the configuration file."

      class_option :full, :type => :boolean, :aliases => "-f",
                   :desc => 'Full installation will install the layout and css overrides for easier customization.'

      def copy_config
        copy_file 'vendor/assets/javascripts/mercury.js', 'app/assets/javascripts/mercury.js'
      end

      def add_routes
        route %Q{Mercury::Engine.routes}
      end

      def copy_layout_and_css_overrides
        if options[:full] || yes?("Install the layout and CSS overrides files? [yN]")
          copy_file 'app/views/layouts/mercury.html.erb', 'app/views/layouts/mercury.html.erb'
          copy_file 'vendor/assets/stylesheets/mercury_overrides.css', 'app/assets/stylesheets/mercury_overrides.css'
        end
      end

      def display_readme
        readme 'POST_INSTALL'
      end

    end
  end
end
