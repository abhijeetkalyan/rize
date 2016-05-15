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
  spec.description   = <<-EOF
Rize is a collection of useful methods that can make it easier to work with functions, arrays and hashes in Ruby. 
It allows you to compose and memoize functions, elegantly iterate over multiple arrays at once, easily map over hash keys and values,
and much more.
Nothing is monkeypatched, so you don't have to worry about the core classes behaving differently than you expect.
  EOF
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
