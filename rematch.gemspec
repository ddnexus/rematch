# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rematch'

Gem::Specification.new do |s|
  s.name        = 'rematch'
  s.version     = Rematch::VERSION
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'Rematch expected values with automatically stored values in tests'
  s.description = 'With rematch you can completely declutter your test files from hardcoded expected data and update them automatically in a few seconds instead of hours when your code changes'
  s.homepage    = 'https://github.com/ddnexus/rematch'
  s.license     = 'MIT'
  s.files       = File.read('rematch.manifest').split
  s.required_ruby_version = '> 2.5'
end
