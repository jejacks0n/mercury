require 'rails'

module Mercury
  class Engine < ::Rails::Engine

    paths['app/helpers']

    # Additional application configuration to include precompiled assets.
    initializer :assets, :group => :all do |app|
      app.config.assets.precompile += %w( mercury.js mercury.css mercury_overrides.css mercury_overrides.js )
    end

    # Require mercury authentication module and potentially other aspects later (so they can be overridden).
    initializer 'mercury.add_lib' do |app|
      require 'mercury/authentication'
    end

  end
end
