# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rematch'

description = 'The "rematch" gem is deprecated and will no longer be maintained. ' \
              'Please switch to "minitest-holdify" (https://rubygems.org/gems/minitest-holdify).'

Gem::Specification.new do |s|
  s.name        = 'rematch'
  s.version     = Rematch::VERSION
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'The "rematch" gem is deprecated. Use minitest-holdify instead.'
  s.description = description
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
  s.post_install_message  = description

end
