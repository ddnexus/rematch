# frozen_string_literal: true

require_relative '../test_helper'
require 'time'

describe 'rematch/stored' do
  it 'rematches entry with stored value' do
    _('stored_value').must_rematch :string_e
    assert_rematch :string_a, 'stored_value'
    _(5..34).must_rematch :range_e
    assert_rematch :range_a, 5..34
    _([1, 4, 5, 6]).must_rematch :array_e
    assert_rematch :array_a, [1, 4, 5, 6]
    _(a: 23, b: { c: ['a', 5] }).must_rematch :nested_hash_e
    assert_rematch(:nested_hash_a, a: 23, b: { c: ['a', 5] })
    _(Time.parse('2021-05-16 12:33:31.101458598 +00:00')).must_rematch :time_e
    assert_rematch :time_a, Time.parse('2021-05-16 12:33:31.101458598 +00:00')
  end
  it 'accepts mixed arguments' do
    _('method first').must_rematch :k1, :assert_equal, 'mixed arguments'
    assert_rematch :k2, 'method first', :assert_equal, 'mixed arguments'
    _('message first').must_rematch :k3, 'mixed arguments', :assert_equal
    assert_rematch :k4, 'message first', 'mixed arguments', :assert_equal
    _('only method').must_rematch :k5, :assert_equal
    assert_rematch :k6, 'only method', :assert_equal
    _('only message').must_rematch :k7, 'mixed arguments'
    assert_rematch :k8, 'only message', 'mixed arguments'
  end
  it 'should fail' do
    # the store contains 'wrong_value' instead of 'right_value' (edit manually if this test fails)
    error = assert_raises(Minitest::Assertion) do
      _('right_value').must_rematch :wrong1
    end
    _(error.message).must_equal "Expected: \"wrong_value\"\n  Actual: \"right_value\""
    error2 = assert_raises(Minitest::Assertion) do
      assert_rematch :wrong2, 'right_value'
    end
    _(error2.message).must_equal "Expected: \"wrong_value\"\n  Actual: \"right_value\""
  end
  it 'should force rematch' do
    error = assert_raises(Minitest::Assertion) do
      store_assert_rematch(:sa, 'store-rematch (right_value)')
    end
    _(error.message).must_equal '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
    error2 = assert_raises(Minitest::Assertion) do
      _('store-rematch (right_value)').store_must_rematch :se
    end
    _(error2.message).must_equal '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
  end
end
