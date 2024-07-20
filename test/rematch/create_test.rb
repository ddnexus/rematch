# frozen_string_literal: true

require_relative '../test_helper'

describe 'rematch/create' do
  store_file = "#{__FILE__}#{Rematch::DEFAULT[:ext]}"
  it 'creates the store and the entry' do
    File.delete(store_file) if File.file?(store_file)
    _('a new value').must_rematch :new_val
    _(store_file).path_must_exist
    _(File.read(store_file)).must_equal <<~STORE
      ---
      rematch/create_test_0001_creates_the_store_and_the_entry:
        :new_val: a new value
    STORE
  end
end
