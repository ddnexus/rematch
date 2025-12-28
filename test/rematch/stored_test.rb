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
    assert_rematch(Time.parse('2021-05-16 12:33:31.101458598 +00:00'))
  end

  it 'accepts all argument combinations' do
    # 1. No extra args
    assert_rematch 'plain'
    _('plain').must_rematch
    # 2. Only Assertion
    assert_rematch 'assertion only', :assert_equal
    _('assertion only').must_rematch :assert_equal
    # 3. Only Message
    assert_rematch 'message only', 'msg'
    _('message only').must_rematch 'msg'
    # 4. Assertion + Message
    assert_rematch 'assertion first', :assert_equal, 'msg'
    _('assertion first').must_rematch :assert_equal, 'msg'
    # 5. Message + Assertion
    assert_rematch 'message first', 'msg', :assert_equal
    _('message first').must_rematch 'msg', :assert_equal
    # 11. Proc Message
    assert_rematch 'proc message', proc { 'lazy msg' }
    _('proc message').must_rematch proc { 'lazy msg' }
    # 12. Proc Message + Assertion
    assert_rematch 'proc msg first', proc { 'lazy msg' }, :assert_equal
    _('proc msg first').must_rematch proc { 'lazy msg' }, :assert_equal
    # 13. Assertion + Proc Message
    assert_rematch 'proc msg last', :assert_equal, proc { 'lazy msg' }
    _('proc msg last').must_rematch :assert_equal, proc { 'lazy msg' }
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

    # Prevent saving the wrong values used for testing failure
    @rematch.instance_variable_get(:@session).clear
  end

  it 'should force rematch' do
    assert_rematch!('store-rematch (right_value)')
    _(@rematch.forced).wont_be_empty
    _('store-rematch (right_value)').must_rematch!
    _(@rematch.forced).wont_be_empty

    @rematch.forced.clear
  end
end
