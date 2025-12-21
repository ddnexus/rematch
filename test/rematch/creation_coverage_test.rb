# frozen_string_literal: true

require_relative '../test_helper'

# ensure there is no store
def delete_store
  FileUtils.rm("#{__FILE__}#{Rematch::CONFIG[:ext]}", force: true)
end

describe 'rematch/creation_coverage' do
  it 'creates multiple key store' do
    delete_store
    expect('stored_value').to_rematch
    expect('stored_value').to_rematch
    expect('stored_value').to_rematch
    delete_store
    error = assert_raises(Minitest::Assertion) do
      store_assert_rematch 'stored_value'
    end
    _(error.message).must_equal '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
    delete_store
  end
end
