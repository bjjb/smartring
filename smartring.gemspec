# frozen_string_literal: true
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'smartring'

Gem::Specification.new do |spec|
  spec.name = 'smartring'
  spec.version = '0.0.1'
  spec.authors = ['JJ Buckley']
  spec.email = ['jj@bjjb.org']
  spec.summary = 'Smartling API client'
  spec.description = <<~DESC
    Ferry documents to be translated from the Salesforce Knowledge Base to
    Smartling, and back again.
DESC
  spec.homepage = 'https://bjjb.github.io/smartring'
  spec.license = 'MIT'
  spec.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] +
               Dir['bin/*'] + Dir['exe/*'] +
               ['README.md', 'LICENSE.txt']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0'
  spec.add_dependency 'dotenv', '~> 2.2'
  spec.add_dependency 'hipsterhash', '~> 0.0.4'
  spec.add_dependency 'httmultiparty', '~> 0.3.16'
  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-vcr', '~> 1.4'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'rack-test', '~> 0.8'
  spec.add_development_dependency 'rerun', '~> 0.13'
  spec.add_development_dependency 'rubocop', '~> 0.53'
  spec.add_development_dependency 'simplecov', '~> 0.15'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.1'
end
