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
    assert_rematch '2021-05-16 12:33:31.101458598 +00:00'
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
    # the store contains 'wrong_value' instead of 'right_value' (edit manually if this test fails)
    assert_raises(Exception) do
      _('right_value').must_rematch
    end
    assert_raises(Exception) do
      assert_rematch 'right_value'
    end
  end
end
