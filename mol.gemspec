# -*- encoding: utf-8 -*-

require File.expand_path('../lib/mol/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "mol"
  spec.version       = MOL::VERSION
  spec.summary       = %q{MOL Ruby}
  spec.description   = %q{Ruby wrapper for MOL Payout API.}
  spec.license       = "MIT"
  spec.authors       = ["Mark Sargento"]
  spec.email         = "iammac.dicoder@gmail.com"
  spec.homepage      = "https://github.com/iammac360/mol#readme"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'httparty', '~> 0.13.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0.beta2'
  spec.add_development_dependency 'rubygems-tasks', '~> 0.2'
  spec.add_development_dependency 'webmock', '~> 1.17.4'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'yard', '~> 0.8'
end
