# frozen_string_literal: true

require_relative '../test_helper'

describe 'rematch/create' do
  store_path = "#{__FILE__}#{Rematch::CONFIG[:ext]}"

  before do
    File.delete(store_path) if File.file?(store_path)
    Rematch.stores.delete(__FILE__)
  end

  it 'creates the store and the entry' do
    _, err = capture_io do
      expect('a new value').to_rematch
    end
    _(err).must_match(/\[rematch\] Stored new value for .*create_test.rb:15/)

    instance_variable_get(:@rematch).save
    value(store_path).path_must_exist
    _(File.read(store_path)).must_equal <<~STORE
      ---
      L15 c13516d366b1ca97c59de35d611ba3158a0ab11b:
      - a new value
    STORE
  end
end
