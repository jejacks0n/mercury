# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'mercury/version'

Gem::Specification.new do |s|

  # General Gem Information
  s.name        = 'mercury-rails'
  s.date        = '2017-08-25'
  s.version     = Mercury::VERSION
  s.authors     = ['Jeremy Jackson']
  s.email       = ['jejacks0n@gmail.com']
  s.homepage    = 'http://github.com/jejacks0n/mercury'
  s.summary     = %Q{Mercury Editor: The Rails HTML5 WYSIWYG editor}
  s.description = %Q{A fully featured and advanced HTML5 WYSIWYG editor written in CoffeeScript on top of the Rails asset pipeline}
  s.licenses    = ['MIT']

  # Runtime Dependencies
  s.add_dependency 'railties'
  s.add_dependency 'coffee-rails'

  # Gem Files
  s.extra_rdoc_files  = %w(LICENSE POST_INSTALL)
  # = MANIFEST =
  s.files             = Dir['lib/**/*', 'vendor/assets/**/*', 'app/**/*', 'db/migrate/*', 'config/engine.rb', 'config/routes.rb']
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # = MANIFEST =
  s.require_paths     = %w(lib)

end
