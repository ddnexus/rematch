# frozen_string_literal: true

require_relative '../test_helper'
require 'minitest/unordered'

module Minitest
  module Assertions
    # stupid assertion in real world, but good for testing
    def assert_equal_insensitive(expected, actual, msg = nil)
      assert_equal expected.downcase, actual.downcase, msg
    end
  end
end

describe 'rematch/equality' do
  it 'rematches :assert_equal_insensitive' do
    # the store contains 'MIXED_case' instead of 'mixed_CASE' (edit manually if rebuilt)
    _('mixed_CASE').must_rematch :mixE, :assert_equal_insensitive
    assert_rematch :mixA, 'mixed_CASE', :assert_equal_insensitive
  end
  it 'rematches :assert_equal_unordered' do
    # assert_equal_unordered [2,1,3], [1,2,3]
    # the store contains [2,1,3] instead of [1,2,3] (edit manually if rebuilt)
    _([1, 2, 3]).must_rematch :k1, :assert_equal_unordered
    assert_rematch :k2, [1, 2, 3], :assert_equal_unordered
  end
end
