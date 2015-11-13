# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gimp/version'

Gem::Specification.new do |spec|
  spec.name          = "gimp"
  spec.version       = Gimp::VERSION
  spec.authors       = ["Greg Beech"]
  spec.email         = ["greg@gregbeech.com"]

  spec.summary       = %q{GitHub Issue Moving Program}
  spec.description   = %q{Move issues between GitHub repos from the command line.}
  spec.homepage      = "https://github.com/gregbeech/gimp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "octokit", "~> 4.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
