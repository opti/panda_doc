# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panda_doc/version'

Gem::Specification.new do |spec|
  spec.name          = "panda_doc"
  spec.version       = PandaDoc::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Igor Pstyga"]
  spec.email         = ["igor.pstyga@gmail.com"]

  spec.summary       = %q{Ruby wrapper for PandaDoc.com API}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/opti/panda_doc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.2"
  spec.add_dependency "faraday", "~> 0.9.2"
  spec.add_dependency "faraday_middleware", "~> 0.10.0"
  spec.add_dependency "virtus", "~> 1.0", ">= 1.0.5"
  spec.add_dependency "representable", ">= 3.0.0"
end
