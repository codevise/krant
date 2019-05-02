# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'krant/version'

Gem::Specification.new do |spec|
  spec.name          = 'krant'
  spec.version       = Krant::VERSION
  spec.authors       = ['Tim Fischbach']
  spec.email         = ['tfischbach@codevise.de']

  spec.summary       = 'Display app news and broadcast messages in Active Admin.'
  spec.homepage      = 'https://github.com/codevise/krant'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency 'appraisal', '~> 2.2'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'combustion', '~> 0.9.1'
  spec.add_development_dependency 'sqlite3', '~> 1.3.6'
  spec.add_development_dependency 'capybara', '~> 3.0'
  spec.add_development_dependency 'factory_bot_rails', '~> 4.8'
  spec.add_development_dependency 'domino', '~> 0.11.0'
  spec.add_development_dependency 'semmy', '~> 1.0'
  spec.add_development_dependency 'timecop', '~> 0.9.1'

  spec.add_runtime_dependency 'activeadmin', ['>= 1.0', '< 1.4']
  spec.add_runtime_dependency 'rails', '~> 5.1'
  spec.add_runtime_dependency 'kramdown', '~> 1.5'
  spec.add_runtime_dependency 'redcarpet', '~> 3.4'
end
