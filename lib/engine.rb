module Mercury
  class Engine < ::Rails::Engine

    initializer :assets, group: :all do |app|
      ['dependencies', 'fonts', 'javascripts', 'stylesheets'].each do |path|
        app.config.assets.paths << Mercury::Engine.root.join('lib', path).to_s
      end
    end

  end
end
