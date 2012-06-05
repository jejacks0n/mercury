module Mercury
  module Generators
    module Install
      class AuthenticationGenerator < Rails::Generators::Base
        source_root Mercury::Engine.root

        desc "Installs an authentication example so you can restrict access to editing."

        def copy_authentication_overrides
          copy_file 'lib/mercury/authentication.rb'
        end
      end
    end
  end
end
