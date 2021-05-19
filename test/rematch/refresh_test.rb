# frozen_string_literal: true

require_relative '../test_helper'
require 'fileutils'

describe 'rematch/refresh' do

  describe 'refresh the values' do
    it 'check_refresh' do
      Rematch.refresh = true
      store_path = "#{__FILE__}#{Rematch::EXT}"
      Rematch.check_refresh(store_path)
      Rematch.refresh = nil
      _(File.file?(store_path)).must_equal false
      _('store_value').must_rematch
      _(system('ruby -Ilib:test test/rematch/refresh_option.rb --rematch-refresh-only')).must_equal true
    end
  end
end
