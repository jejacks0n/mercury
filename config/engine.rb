require "rails"

module Mercury
  class Engine < Rails::Engine
    
    # To load the routes for this Engine, within your main apps routes.rb file include
    # the following:
    #
    #   Mercury::Engine.routes
    def self.routes
      Rails.application.routes.draw do

        resources :images

        match '/editor(/*requested_uri)' => "mercury#edit", :as => :mercury_editor
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
