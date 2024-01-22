# frozen_string_literal: true

require_relative '../test_helper'

# ensure there is no store
def delete_store
  FileUtils.rm("#{__FILE__}#{Rematch::EXT}", force: true)
end

describe 'rematch/equality' do
  it 'creates multiple key store' do
    delete_store
    _('stored_value').must_rematch :string_a
    _('stored_value').must_rematch :string_b
    _('stored_value').must_rematch :string_c
    delete_store
    error = assert_raises(Minitest::Assertion) do
      store_assert_rematch :string_a, 'stored_value'
    end
    _(error.message).must_equal '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
    delete_store
  end
end
