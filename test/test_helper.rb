# frozen_string_literal: true

require 'simplecov'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest'
Minitest.load :rematch

require 'minitest/autorun'
