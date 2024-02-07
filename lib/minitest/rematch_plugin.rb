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
    def assert_rematch(key, actual, *args)
      assertion = :assert_equal
      message   = nil
      args.each { |arg| arg.is_a?(Symbol) ? assertion = arg : message = arg }
      if actual.nil?   # use specific assert_nil after deprecation of assert_equal nil
        assert_nil @rematch.rematch(key, actual), message
      else
        send assertion, @rematch.rematch(key, actual), actual, message  # assert that the stored value is the same actual value
      end
    end

    # Temporarily used to store the actual value, useful for reconciliation of expected changed values
    def store_assert_rematch(key, actual, *_args)
      @rematch.store(key, actual)
      # Always fail after storing, forcing the restore of the original assertion/expectation
      raise Minitest::Assertion, '[rematch] the value has been stored: remove the "store_" prefix to pass the test'
    end
  end

  # Reopen the minitest module
  module Expectations
    # Add the expectations pointing to the assertions
    infect_an_assertion :assert_rematch, :must_rematch
    infect_an_assertion :store_assert_rematch, :store_must_rematch
  end
end
