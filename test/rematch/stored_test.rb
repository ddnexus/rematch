# frozen_string_literal: true

require_relative '../test_helper'
require 'time'

describe 'rematch/stored' do
  it 'rematches entry with stored value' do
    _('stored_value').must_rematch
    assert_rematch 'stored_value'
    _(5..34).must_rematch
    assert_rematch 5..34
    _([1, 4, 5, 6]).must_rematch
    assert_rematch [1, 4, 5, 6]
    _(a: 23, b: { c: ['a', 5] }).must_rematch
    assert_rematch(a: 23, b: { c: ['a', 5] })
    _(Time.parse('2021-05-16 12:33:31.101458598 +00:00')).must_rematch
    assert_rematch Time.parse('2021-05-16 12:33:31.101458598 +00:00')
  end
  it 'rematches using the id option' do
    # Useful for loops or parameterized tests where the line number is the same
    %w[a b].each do |char|
      assert_rematch char, id: "assert_#{char}"
      _(char).must_rematch id: "must_#{char}"
      expect(char).to_rematch id: "to_#{char}"
    end
  end
  it 'accepts mixed arguments' do
    _('method first').must_rematch :assert_equal, 'mixed arguments'
    assert_rematch 'method first', :assert_equal, 'mixed arguments'
    _('message first').must_rematch 'mixed arguments', :assert_equal
    assert_rematch 'message first', 'mixed arguments', :assert_equal
    _('only method').must_rematch :assert_equal
    assert_rematch 'only method', :assert_equal
    _('only message').must_rematch 'mixed arguments'
    assert_rematch 'only message', 'mixed arguments'
  end
  it 'should fail' do
    # the store contains 'right_value' instead of 'wrong_value' (edit manually if this test fails)
    error = assert_raises(Minitest::Assertion) do
      _('wrong_value').must_rematch
    end
    _(error.message).must_equal "Expected: \"right_value\"\n  Actual: \"wrong_value\""
    error2 = assert_raises(Minitest::Assertion) do
      assert_rematch 'wrong_value'
    end
    _(error2.message).must_equal "Expected: \"right_value\"\n  Actual: \"wrong_value\""
  end
  it 'should force rematch' do
    error = assert_raises(Minitest::Assertion) do
      store_assert_rematch('store-rematch (right_value)')
    end
    _(error.message).must_equal '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
    error2 = assert_raises(Minitest::Assertion) do
      _('store-rematch (right_value)').store_must_rematch
    end
    _(error2.message).must_equal '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
  end
end
