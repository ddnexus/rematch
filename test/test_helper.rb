# frozen_string_literal: true

if ENV['CODECOV']
  require 'codecov'   # requires also simplecov
  # if you want the formatter to upload the results use SimpleCov::Formatter::Codecov instead
  SimpleCov.formatter = Codecov::SimpleCov::Formatter  # upload with step in github actions
elsif !ENV['CI']
  require 'simplecov'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rematch'
require 'minitest/autorun'
