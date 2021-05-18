# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rematch'

Gem::Specification.new do |s|
  s.name        = 'rematch'
  s.version     = Rematch::VERSION
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'Rematch expected test values with automatically stored values'
  s.description = 'Declutter your test files from large hardcoded data and update them automatically when your code changes'
  s.homepage    = 'https://github.com/ddnexus/rematch'
  s.license     = 'MIT'
  s.files       = File.read('rematch.manifest').split
  s.required_ruby_version = '> 2.1'   # rubocop:disable Gemspec/RequiredRubyVersion # we test from 5.4 but it should work on 2.1
end
