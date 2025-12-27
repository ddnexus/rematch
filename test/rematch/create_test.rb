# frozen_string_literal: true

require_relative '../test_helper'

describe 'rematch/create' do
  store_path = "#{__FILE__}#{Rematch::CONFIG[:ext]}"
  it 'creates the store and the entry' do
    File.delete(store_path) if File.file?(store_path)
    expect('a new value').to_rematch
    instance_variable_get(:@rematch).save
    value(store_path).path_must_exist
    _(File.read(store_path)).must_equal <<~STORE
      ---
      L9 c13516d366b1ca97c59de35d611ba3158a0ab11b:
      - rematch_value: a new value
    STORE
  end
end
