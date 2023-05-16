# frozen_string_literal: true

require_relative "lib/panda_doc/version"

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
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7"
  spec.add_dependency "faraday", ">= 2.0.1", "< 3.0"
  spec.add_dependency "faraday-multipart", ">= 1.0.0", "< 2.0"
  spec.add_dependency "dry-configurable"
  spec.add_dependency "dry-struct"
end
