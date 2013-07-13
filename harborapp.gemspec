# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'harborapp/version'

Gem::Specification.new do |spec|
  spec.name          = "harborapp"
  spec.version       = Harborapp::VERSION
  spec.authors       = ["Bryan Thompson"]
  spec.email         = ["bryan@madebymarket.com"]
  spec.description   = %q{CLI for the https://harbor.madebymarket.com file transfer application}
  spec.summary       = %q{CLI for the https://harbor.madebymarket.com file transfer application}
  spec.homepage      = "https://harbor.madebymarket.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
