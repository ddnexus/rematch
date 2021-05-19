# frozen_string_literal: true

# The name of this file doesn't match the pattern (_test) for being
# picked up by the rake task, so it runs only as a system call from the refresh_test.rb:
# system('ruby -Ilib:test test/rematch/refresh_option.rb --rematch-refresh-only')

require_relative '../test_helper'

describe 'rematch/refresh_option' do

  describe 'refresh the values' do
    it 'must output' do
      store_path = "#{__FILE__}#{Rematch::EXT}"
      _(File.file?(store_path)).must_equal false   # the refresh should have deleted the file
      _('store_value').must_rematch
      _(File.file?(store_path)).must_equal true    # the test before should have created the file
    end
  end
end
