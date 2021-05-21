# frozen_string_literal: true

# The name of this file doesn't match the pattern (_test) for being
# picked up by the rake task, so it runs only as a system call from the rebuild_test.rb:
# system('ruby -Ilib:test test/rematch/rebuild_option.rb --rematch-rebuild')
# in order to test the --rematch-rebuild option only on this file

require_relative '../test_helper'

describe 'rematch/rebuild_option' do
  it 'rebuilds the store' do
    store_path = "#{__FILE__}#{Rematch::EXT}"
    _(File.file?(store_path)).must_equal false   # the rebuild should have deleted the file
    _('store_value').must_rematch
    _(File.file?(store_path)).must_equal true    # the test above should have created the file
  end
end
