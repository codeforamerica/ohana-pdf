# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api2pdf/version'

Gem::Specification.new do |spec|
  spec.name          = "api2pdf"
  spec.version       = Api2pdf::VERSION
  spec.authors       = ["Tu Hoang"]
  spec.email         = ["rebyn@me.com"]
  spec.description   = "Pretty-prints JSON-based API to PDF."
  spec.summary       = "Pretty-prints JSON-based API to PDF."
  spec.homepage      = "https://github.com/rebyn/api2pdf"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "httparty"
  spec.add_development_dependency "active_support"
  spec.add_development_dependency "prawn"

  spec.add_development_dependency "rspec", ">= 2.11"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
end
