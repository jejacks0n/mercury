require "mercury/engine"

module Mercury
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root Mercury::Engine.root

      desc "Installs Mercury into your application by copying the configuration file."

      class_option :full, :type => :boolean, :aliases => '-g',
                   :desc => 'Full installation will install the layout and css files for easier customization.'

      class_option :template_engine, :type => :string,
                   :desc => 'Set preferred template engine for layout instead of ERB (haml or slim)'

      def create_mercury_database
        generate(:model, "MercuryContents mercury_contents name:string:uniq value:text type:string data:text slug:string settings:text width:string height:string")
        remove_file 'app/models/mercury_contents.rb'
        remove_file 'spec/models/mercury_contents_spec.rb'

        generate(:model, "MercuryImages mercury_images image:string width:string height:string")
        remove_file 'app/models/mercury_images.rb'
        remove_file 'spec/models/mercury_images_spec.rb'

        generate(:model, "MercurySnippets mercury_snippets snippet:text name:string:uniq")
        remove_file 'app/models/mercury_snippets.rb'
        remove_file 'spec/models/mercury_snippets_spec.rb'
      end

      def copy_config
        copy_file 'app/assets/javascripts/mercury.js'
      end

      def add_routes
        route %Q{mount Mercury::Engine => '/'}
      end

      def copy_layout_and_css_overrides
        layout_ext = options[:template_engine] || 'erb'
        copy_file "app/views/layouts/mercury.html.#{layout_ext}"
        copy_file 'app/assets/stylesheets/mercury.css'
      end

      def display_readme
        readme 'POST_INSTALL' if behavior == :invoke
      end

    end
  end
end
