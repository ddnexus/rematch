# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rematch'

Gem::Specification.new do |s|
  s.name        = 'rematch'
  s.version     = Rematch::VERSION
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'Declutter your test files and automatically update expected values.'
  s.description = 'Rematch declutters your tests by storing large outputs or structures ' \
                  'in separate files. It verifies them automatically and enables easy ' \
                  'updates when your code changes, eliminating tedious copy-paste maintenance.'
  s.homepage    = 'https://github.com/ddnexus/rematch'
  s.license     = 'MIT'
  s.files       = Dir['lib/**/*.rb'] + ['LICENSE.txt']
  s.metadata    = { 'rubygems_mfa_required' => 'true',
                    'homepage_uri'          => 'https://github.com/ddnexus/rematch',
                    'bug_tracker_uri'       => 'https://github.com/ddnexus/rematch/issues',
                    'changelog_uri'         => 'https://github.com/ddnexus/rematch/blob/master/CHANGELOG.md' }
  s.add_dependency 'logger'
  s.add_dependency 'pstore'
  s.required_ruby_version = '> 3.2' # Ruby EOL
end
