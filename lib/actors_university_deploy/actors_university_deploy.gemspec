# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'actors_university_deploy/version'

Gem::Specification.new do |spec|
  spec.name          = "actors_university_deploy"
  spec.version       = ActorsUniversityDeploy::VERSION
  spec.authors       = ["Jack Silver"]
  spec.email         = ["jack@jacksilver.tv"]
  spec.description   = %q{description}
  spec.summary       = %q{summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "semaphoreapp"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
