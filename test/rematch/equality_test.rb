# frozen_string_literal: true

require_relative '../test_helper'
require "minitest/unordered"

module Minitest
  module Assertions
    # stupid assertion in real world, but good for testing
    def assert_equal_insensitive(expected, actual)
      assert_equal expected.downcase, actual.downcase
    end
  end
end

describe 'rematch/equality' do
  it 'rematches upcase equality' do
    # the store contains 'MIXED_case' instead of 'mixed_CASE' (edit manually if this test fails)
    _('mixed_CASE').must_rematch :equal_insensitive   # the stored value is 'MIXED_case' instead
  end
  it 'rematches equal-unordered plugin' do
    # [1,2,3].must_equal_unordered [2,1,3]
    # the store contains [2,1,3] instead of [1,2,3] (edit manually if this test fails)
    _([1,2,3]).must_rematch :equal_unordered   # the stored value is 'MIXED_case' instead
  end
end
