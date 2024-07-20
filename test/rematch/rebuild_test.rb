# frozen_string_literal: true

require_relative '../test_helper'
require 'fileutils'

describe 'rematch/rebuild' do
  it 'refreshes the value with check_rebuild' do
    Rematch.rebuild = true
    store_path = "#{__FILE__}#{Rematch::DEFAULT[:ext]}"
    Rematch.check_rebuild(store_path)
    Rematch.rebuild = nil
    _(store_path).path_wont_exist
    _('store_value').must_rematch :store
    assert system('ruby -Ilib:test test/rematch/rebuild_option.rb --rematch-rebuild')
  end
end
