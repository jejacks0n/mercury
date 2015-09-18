# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'mercury/version'

Gem::Specification.new do |s|

  # General Gem Information
  s.name        = 'mercury-rails'
  s.date        = '2012-10-19'
  s.version     = Mercury::VERSION
  s.authors     = ['Jeremy Jackson']
  s.email       = ['jejacks0n@gmail.com']
  s.homepage    = 'http://github.com/mediatainment/mercury'
  s.summary     = %Q{Mercury Editor: The Rails HTML5 WYSIWYG editor}
  s.description = %Q{A fully featured and advanced HTML5 WYSIWYG editor written in CoffeeScript on top of the Rails asset pipeline}
  s.licenses    = ['MIT']

  # Runtime Dependencies
  s.add_dependency 'railties', '>= 3.0'
  s.add_dependency 'coffee-rails', '>= 3.2.2'
  s.add_dependency 'mini_magick', '>= 4.2.4'
  s.add_dependency 'carrierwave', '>= 0.10.0'
  s.add_dependency 'dropzonejs-rails', '>= 0.7.1'

  # Gem Files
  s.extra_rdoc_files  = %w(LICENSE POST_INSTALL)
  s.post_install_message = 'Mercury Post install \n PLEASE Run "rails generate mercury:install"'
  # = MANIFEST =
  s.files             = Dir['lib/**/*', 'vendor/assets/**/*', 'app/**/*', 'db/migrate/*', 'config/engine.rb', 'config/routes.rb']
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # = MANIFEST =
  s.require_paths     = %w(lib)

end
