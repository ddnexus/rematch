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
    expect('mixed_CASE').to_rematch :assert_equal_insensitive
    assert_rematch 'mixed_CASE', :assert_equal_insensitive
  end

  describe Rematch do
    it 'rematches nested describe' do
      expect('a value').to_rematch
    end
  end

  it 'rematches :assert_equal_unordered' do
    # assert_equal_unordered [2,1,3], [1,2,3]
    # the store contains [2,1,3] instead of [1,2,3] (edit manually if rebuilt)
    array = [1, 2, 3]
    _(array).must_rematch :assert_equal_unordered
    value(array).must_rematch :assert_equal_unordered
    expect(array).to_rematch :assert_equal_unordered
    assert_rematch array, :assert_equal_unordered
  end

  it 'rematches :assert_nil' do
    expect(nil).to_rematch
  end

  it 'rematches empty value' do
    expect("").to_rematch
  end
end
