# frozen_string_literal: true

# This file is run via system call from test/rematch/rebuild_test.rb
# It is NOT named *_test.rb to avoid being picked up by the default rake task

require_relative '../test_helper'

describe 'rematch/rebuild_option' do
  it 'rebuilds the store' do
    store_path = "#{__FILE__}#{Rematch::CONFIG[:ext]}"
    # 1. Verify Rebuild: The flag should have triggered deletion in Rematch.new
    value(store_path).path_wont_exist
    expect('store_value').to_rematch
    # 2. Verify Creation: We must force a save because Rematch now buffers writes
    instance_variable_get(:@rematch).save
    value(store_path).path_must_exist
  end
end
