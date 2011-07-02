module Mercury
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root Mercury::Engine.root

      desc "Installs Mercury into your application by copying the configuration file."

      def copy_config
        copy_file 'vendor/assets/javascripts/mercury.js', 'app/assets/javascripts/mercury.js'
      end

    end
  end
end
