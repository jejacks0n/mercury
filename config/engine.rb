require "rails"

module Mercury
  class Engine < Rails::Engine

    # We use these things for our development, but you don't have to.
#    config.app_generators do |g|
#      g.orm                 :active_record
#      g.template_engine     :haml
#      g.scaffold_controller :scaffold_controller # to kill off responders_controller
#    end

    # Add additional load paths for your own custom dirs.
#    config.autoload_paths += %W( #{root}/lib/app #{root}/app/templates #{root}/app/snippets )

    # Configure the default encoding used in templates for Ruby 1.9.
#    config.encoding = "utf-8"


    # Add our rake tasks for use in the applications
#    rake_tasks do
#      Dir.glob(root.join('lib', 'app', 'tasks', '*.rake')).each do |file|
#        load file
#      end
#    end

#
#    # Configure the rack middleware modules.
#    initializer "protosite.add_middleware" do |app|
#      app.middleware.insert_before ::ActionDispatch::ParamsParser, Rack::DetectPlatform
#      app.middleware.insert_before ::Rack::Lock, Middleware::Jammit
#
#      # todo: I *think* this can and should go away now
#      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
#    end

  end
end
