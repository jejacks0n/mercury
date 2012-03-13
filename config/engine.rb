require "rails"

module Mercury
  class Engine < Rails::Engine

    # Additional application configuration to include precompiled assets.
    initializer :assets, :group => :all do |app|
      app.config.assets.precompile += %w( mercury.js mercury.css mercury_overrides.css )
    end

    # Require mercury authentication module and potentially other aspects later (so they can be overridden).
    initializer 'mercury.add_lib' do |app|
      require 'mercury/authentication'
    end

    # To load the routes for this Engine, within your main apps routes.rb file include:
    #
    # Mercury::Engine.routes
    #
    def self.routes
      Rails.application.routes.draw do
        match '/editor(/*requested_uri)' => "mercury#edit", :as => :mercury_editor

        namespace :mercury do
          resources :images
        end

        scope '/mercury' do
          match ':type/:resource' => "mercury#resource"
          match 'snippets/:name/options' => "mercury#snippet_options"
          match 'snippets/:name/preview' => "mercury#snippet_preview"
        end

        if defined?(Mercury::Application)
          match 'mercury/test_page' => "mercury#test_page"
        end
      end
    end

  end
end
