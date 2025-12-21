# frozen_string_literal: true

require_relative '../test_helper'

describe 'rematch/create' do
  store_path = "#{__FILE__}#{Rematch::CONFIG[:ext]}"
  it 'creates the store and the entry' do
    File.delete(store_path) if File.file?(store_path)
    expect('a new value').to_rematch
    value(store_path).path_must_exist
    _(File.read(store_path)).must_equal <<~STORE
      ---
      L9 770340a3ba63a77e0b0cc28e2ab660f04267ab60: a new value
    STORE
  end
end
