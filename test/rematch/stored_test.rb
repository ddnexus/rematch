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

  it 'rematches using the id option' do
    # Useful for loops or parameterized tests where the line number is the same
    %w[a b].each do |char|
      assert_rematch char, label: "assert_#{char}"
      _(char).must_rematch label: "must_#{char}"
      expect(char).to_rematch label: "to_#{char}"
    end
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
    # 6. ID only
    assert_rematch 'id only', label: 'id1'
    _('id only').must_rematch label: 'id2'
    # 7. ID + Assertion
    assert_rematch 'id assertion', :assert_equal, label: 'id3'
    _('id assertion').must_rematch :assert_equal, label: 'id4'
    # 8. ID + Message
    assert_rematch 'id message', 'msg', label: 'id5'
    _('id message').must_rematch 'msg', label: 'id6'
    # 9. ID + Assertion + Message
    assert_rematch 'id all 1', :assert_equal, 'msg', label: 'id7'
    _('id all 1').must_rematch :assert_equal, 'msg', label: 'id8'
    # 10. ID + Message + Assertion
    assert_rematch 'id all 2', 'msg', :assert_equal, label: 'id9'
    _('id all 2').must_rematch 'msg', :assert_equal, label: 'id10'
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
