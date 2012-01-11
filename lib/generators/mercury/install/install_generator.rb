module Mercury
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root Mercury::Engine.root

      desc "Installs Mercury into your application by copying the configuration file."

      class_option :orm, :default => 'active_record', :banner => 'mongoid',
                   :desc => 'ORM for required models -- active_record, or mongoid'

      class_option :full, :type => :boolean, :aliases => '-g',
                   :desc => 'Full installation will install the layout and css overrides for easier customization.'

      def copy_config
        copy_file 'vendor/assets/javascripts/mercury.js', 'app/assets/javascripts/mercury.js'
      end

      def add_routes
        route %Q{Mercury::Engine.routes}
      end

      def copy_models
        if options[:orm] == 'mongoid'
          copy_file 'lib/generators/mercury/install/templates/mongoid_paperclip_image.rb', 'app/models/mercury/image.rb'
        else
          copy_file 'app/models/mercury/image.rb' if options[:full]
        end
      end

      def copy_layout_and_css_overrides
        if options[:full] || yes?("Install the layout and CSS overrides files? [yN]")
          copy_file 'app/views/layouts/mercury.html.erb', 'app/views/layouts/mercury.html.erb'
          copy_file 'vendor/assets/stylesheets/mercury_overrides.css', 'app/assets/stylesheets/mercury_overrides.css'
        end
      end

      def copy_authentication_overrides
        if options[:full] || yes?("Install the authentication file so you can restrict access to editing? [yN]")
          copy_file 'lib/mercury/authentication.rb'
        end
      end

      def display_readme
        readme 'POST_INSTALL' if behavior == :invoke
      end

    end
  end
end
