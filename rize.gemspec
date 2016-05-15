# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rize/version'

Gem::Specification.new do |spec|
  spec.name          = "rize"
  spec.version       = Rize::VERSION
  spec.authors       = ["abhijeetkalyan"]
  spec.email         = ["abhijeetkalyan@gmail.com"]

  spec.summary       = %q{A functional toolkit for Ruby.}
  spec.description   = %q{A collection of useful utilities for manipulating functions, arrays and hashes.}
  spec.homepage      = "https://github.com/abhijeetkalyan/rize"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "byebug", "~> 8.2"
  spec.add_development_dependency "pry", "~> 0.10.3"
end
