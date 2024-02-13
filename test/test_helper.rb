# frozen_string_literal: true

require 'simplecov'

unless ENV['RM_INFO']   # RubyMine safe
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end

# We cannot use 'gemspec' in the gemfile which would load rematch before simplecov so missing files from coverage
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rematch'
require 'minitest/autorun'
