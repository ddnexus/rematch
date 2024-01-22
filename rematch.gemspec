# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rematch'

Gem::Specification.new do |s|
  s.name        = 'rematch'
  s.version     = Rematch::VERSION
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'Declutter your test files from large hardcoded data ' \
                  'and update them automatically when your code changes'
  s.description = 'Instead of copying and pasting large outputs or big ruby structures ' \
                  'into all the affected test files every time your code change, ' \
                  'you can do it the easy way, possibly saving many hours of boring maintenance work!'
  s.homepage    = 'https://github.com/ddnexus/rematch'
  s.license     = 'MIT'
  s.files       = File.read('rematch.manifest').split
  s.metadata    = { 'rubygems_mfa_required' => 'true',
                    'homepage_uri'          => 'https://github.com/ddnexus/rematch',
                    'bug_tracker_uri'       => 'https://github.com/ddnexus/rematch/issues',
                    'changelog_uri'         => 'https://github.com/ddnexus/rematch/blob/master/CHANGELOG.md' }
  s.required_ruby_version = '> 3.1' # Ruby EOL
end
