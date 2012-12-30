Teabag.setup do |config|

  config.root = Mercury::Engine.root

  config.suite do |suite|
    suite.javascripts = ["teabag/jasmine"]
  end

end
