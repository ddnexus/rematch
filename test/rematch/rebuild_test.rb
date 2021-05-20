# frozen_string_literal: true

require_relative '../test_helper'
require 'fileutils'

describe 'rematch/rebuild' do
  it 'refresh the value with check_rebuild' do
    Rematch.rebuild = true
    store_path = "#{__FILE__}#{Rematch::EXT}"
    Rematch.check_rebuild(store_path)
    Rematch.rebuild = nil
    _(File.file?(store_path)).must_equal false
    _('store_value').must_rematch
    _(system('ruby -Ilib:test test/rematch/rebuild_option.rb --rematch-rebuild')).must_equal true
  end
end
