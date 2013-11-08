# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'workon/version'

Gem::Specification.new do |spec|
  spec.name          = "workon"
  spec.version       = Workon::VERSION
  spec.authors       = ["David Furber"]
  spec.email         = ["furberd@gmail.com"]
  spec.description   = %q{Opens project in RubyMine, starts guard, starts Rails server.}
  spec.summary       = %q{Go to your project folder and type workon.}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.executables = ["workon", "fix_windows.sh", "term", "window_funcs.inc", "work.sh"]

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_dependency "foreman"
  spec.add_development_dependency "bundler", "~> 1.3"
  # spec.add_development_dependency "rake"
end
