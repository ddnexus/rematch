# frozen_string_literal: true

require_relative '../test_helper'

# ensure there is no store
def delete_store
  FileUtils.rm_f("#{__FILE__}#{Rematch::CONFIG[:ext]}")
end

describe 'rematch/identical_cases' do
  it 'creates multiple key store' do
    delete_store
    assert_rematch! 'stored_value'
    _(@rematch.forced).wont_be_empty
    @rematch.forced.clear
    delete_store
    expect('stored_value').to_rematch
    expect('stored_value').to_rematch
    expect('stored_value').to_rematch
    expect('stored_value').to_rematch
    expect('stored_value').to_rematch
    expect('stored_value').to_rematch
    # delete_store
  end
end
