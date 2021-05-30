# frozen_string_literal: true

require_relative '../test_helper'

describe 'rematch/create' do
  store_file = "#{__FILE__}#{Rematch::EXT}"
  it 'creates the store and the entry' do
    File.delete(store_file) if File.file?(store_file)
    _('a new value').must_rematch
    _(store_file).path_must_exist
    _(File.read(store_file)).must_equal <<~STORE
      ---
      "[1] rematch/create#test_0001_creates the store and the entry": a new value
    STORE
  end
end
