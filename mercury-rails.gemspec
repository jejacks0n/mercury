# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'mercury/version'

Gem::Specification.new do |s|

  # General Gem Information
  s.name        = 'mercury-rails'
  s.date        = '2012-06-05'
  s.version     = Mercury::VERSION
  s.authors     = ['Jeremy Jackson']
  s.email       = ['jejacks0n@gmail.com']
  s.homepage    = 'http://github.com/jejacks0n/mercury'
  s.summary     = %Q{Mercury Editor: The Rails HTML5 WYSIWYG editor}
  s.description = %Q{A fully featured and advanced HTML5 WYSIWYG editor written in CoffeeScript on top of the Rails asset pipeline}
  s.licenses    = ['MIT']


  # Runtime Dependencies
  s.add_dependency 'rails', '~> 3.2'
  s.add_dependency 'coffee-rails'

  # Development Dependencies
  s.add_development_dependency 'sprockets', '~> 2.1'
  s.add_development_dependency 'uglifier'
  s.add_development_dependency 'sprockets-rails'

  # Testing dependencies
  s.add_development_dependency 'rspec-core', '>= 2.8.0'
  s.add_development_dependency 'evergreen', '>= 1.0.0'
  s.add_development_dependency 'selenium-webdriver', '>= 2.20.0'
  s.add_development_dependency 'cucumber-rails', '>= 1.3.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-firebug', '>= 1.1.0'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'database_cleaner'

  # Gem Files
  s.extra_rdoc_files  = %w(LICENSE POST_INSTALL)
  # = MANIFEST =
  s.files             = Dir['lib/**/*', 'vendor/assets/**/*', 'app/**/*', 'db/migrate/*', 'config/engine.rb', 'config/routes.rb']
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # = MANIFEST =
  s.require_paths     = %w(lib)

end
