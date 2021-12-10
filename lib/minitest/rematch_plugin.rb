# frozen_string_literal: true

require 'rematch'

# Implement the minitest plugin
module Minitest
  # Set Rematch.rebuild with the --rematch-rebuild
  def self.plugin_rematch_options(opts, _options)
    opts.on '--rematch-rebuild', 'Rebuild the stores with the current entries/values' do
      Rematch.rebuild = true
    end
  end

  # Reopen the minitest class
  class Test
    # Create the rematch object for each test
    def before_setup
      super
      @rematch = Rematch.new(path: method(name).source_location.first, id: location)
    end
  end

  # Reopen the minitest module
  module Assertions
    # Main assertion
    def assert_rematch(actual, *args)
      assertion = :assert_equal
      message   = nil
      args.each { |arg| arg.is_a?(Symbol) ? assertion = arg : message = arg }
      send assertion, @rematch.rematch(actual), actual, message  # assert that the stored value is the same actual value
    end

    # Temporarily used to store the actual value, useful for reconciliation of expected changed values
    def store_assert_rematch(actual, *_args)
      @rematch.store(actual)
      # Always fail after storing, forcing the restore of the original assertion/expectation
      raise Minitest::Assertion, '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
    end
  end

  # Reopen the minitest module
  module Expectations
    # Add the expectations pointing to the assertions
    infect_an_assertion :assert_rematch, :must_rematch, true # dont_flip
    infect_an_assertion :store_assert_rematch, :store_must_rematch, true # dont_flip
  end
end
