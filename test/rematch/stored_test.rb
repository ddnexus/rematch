# frozen_string_literal: true

require_relative '../test_helper'
require 'time'

describe 'rematch/stored' do
  it 'rematches entry with stored value' do
    _('stored_value').must_rematch
    _(5..34).must_rematch
    _([1,4,5,6]).must_rematch
    _(a: 23, b: { c: ['a', 5]}).must_rematch
    _(Time.parse('2021-05-16 12:33:31.101458598 +00:00')).must_rematch
  end
  it 'should fail' do
    # the store contains 'wrong_value' instead of 'right_value' (edit manually if this test fails)
    _ { _('right_value').must_rematch }.must_raise Exception
  end
end
