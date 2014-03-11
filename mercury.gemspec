Gem::Specification.new do |s|
  s.name        = 'mercury'
  s.version     = '2.0.0'
  s.authors     = ['jejacks0n']
  s.email       = ['jejacks0n@gmail.com']
  s.homepage    = "https://github.com/jejacks0n/mercury"
  s.summary     = "Mercury Editor: The HTML5 WYSIWYG editor"
  s.description = "A fully featured and advanced HTML5 WYSIWYG editor written in CoffeeScript"
  s.license     = "MIT"

  s.files       = Dir["{lib,distro}/**/*"] + ["MIT.LICENSE", "README.md"]
  s.test_files  = `git ls-files -- {spec,test}/*`.split("\n")
end
