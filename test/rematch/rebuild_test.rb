# frozen_string_literal: true

require_relative '../test_helper'

describe 'rematch/rebuild' do
  it 'runs the rebuild option test' do
    # Run the isolated test file with the rebuild flag
    # This ensures the flag is tested without affecting the main suite
    cmd = 'ruby -Ilib:test test/rematch/rebuild_option.rb --rematch-rebuild'

    # Capture output to keep main test output clean, unless it fails
    output = `#{cmd} 2>&1`
    result = $?.success? # rubocop:disable Style/SpecialGlobalVars

    puts output unless result
    _(result).must_equal true
  end
end
