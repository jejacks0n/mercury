unless defined?(Rails) # Set RAILS_ROOT and load the environment.
  ENV['RAILS_ROOT'] = File.expand_path('..', __FILE__)
  load File.expand_path('../../config.ru', __FILE__)
end

Teaspoon.configure do |config|
  config.asset_paths  = ['spec', 'spec/support']
  config.fixture_paths = ['spec/fixtures']
  config.use_coverage = :default

  config.suite do |suite|
    suite.use_framework :mocha
    suite.matcher       = 'spec/**/*_spec.{js,js.coffee,coffee}'
    suite.javascripts   += ['support/chai', 'support/sinon', 'support/sinon-chai']
    suite.no_coverage   << %r(/dependencies|/templates)
  end

  config.coverage do |coverage|
    coverage.reports = ['text', 'html', 'cobertura']
  end
end
