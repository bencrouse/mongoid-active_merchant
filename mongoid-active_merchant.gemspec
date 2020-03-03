# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/active_merchant/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-active_merchant"
  spec.version       = Mongoid::ActiveMerchant::VERSION
  spec.authors       = ["Ben Crouse"]
  spec.email         = ["bencrouse@gmail.com"]

  spec.summary       = %q{Adds Mongoid serialization to ActiveMerchant responses}
  spec.homepage      = "https://github.com/bencrouse/mongoid-active_merchant"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'mongoid', '>= 4.0.0'
  spec.add_dependency 'activemerchant', '>= 1.52'

  spec.add_development_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
end
