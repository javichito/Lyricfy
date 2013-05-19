# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lyricfy/version'

Gem::Specification.new do |gem|
  gem.name          = "lyricfy"
  gem.version       = Lyricfy::VERSION
  gem.authors       = ["Javier Hidalgo"]
  gem.email         = ["hola@soyjavierhidalgo.com"]
  gem.description   = %q{Song Lyrics for your Ruby apps}
  gem.summary       = %q{Lyricfy lets you get song lyrics that you can use on your apps}
  gem.homepage      = "https://github.com/javichito/lyricfy"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "nokogiri", [">= 1.3.3"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "webmock", ["1.8.0"]
  gem.add_development_dependency "vcr", ["~> 2.4.0"]
end
