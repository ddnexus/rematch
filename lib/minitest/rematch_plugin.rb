# frozen_string_literal: true

require 'rematch'

# Implement the minitest plugin
module Minitest
  # Set Rematch.rebuild with the --rematch-rebuild
  def self.plugin_rematch_options(opts, _options)
    opts.on '--rematch-rebuild', 'Rebuild the stores with the current entries/values' do
      Rematch.rebuild      = true
      Rematch.skip_warning = true
    end
    # :nocov:
    opts.on '--rematch-skip-warning', 'Skip the warning on storing a new value' do
      Rematch.skip_warning = true
    end
    # :nocov:
  end

  # Reopen the minitest class
  class Test
    # Create the rematch object for each test
    def after_setup
      super
      @rematch = Rematch.new(self)
    end

    # Ensure store is tidied and saved after the test runs
    def before_teardown
      super
      @rematch&.save
      return unless @rematch&.forced&.any? && failures.empty?

      locations = @rematch.forced.uniq.map { |l| "  #{l}" }.join("\n")
      raise Minitest::Assertion, "[rematch] the value has been stored: remove the \"!\" suffix to pass the test\n#{locations}"
    end
  end

  # Reopen the minitest module
  module Assertions
    # Main assertion
    def assert_rematch(actual, *args)
      assertion, message = args
      assertion, message = message, assertion unless assertion.nil? || assertion.is_a?(Symbol)
      if actual.nil? # use specific assert_nil after deprecation of assert_equal nil
        assert_nil @rematch.rematch(actual), message
      else # assert that the stored value is the same actual value
        send assertion || :assert_equal, @rematch.rematch(actual), actual, message
      end
    end

    # Temporarily used to store the actual value, useful for reconciliation of expected changed values
    def assert_rematch!(actual, *)
      @rematch.rematch(actual, force: true)
    end
  end

  # Register expectations only if minitest/spec is loaded; ensure the right class in 6.0 and < 6.0
  if (expectation_class = defined?(Spec) && (defined?(Expectation) ? Expectation : Expectations))
    expectation_class.infect_an_assertion :assert_rematch, :must_rematch, :reverse
    expectation_class.alias_method :to_rematch, :must_rematch # to use with expect().to_rematch
    expectation_class.infect_an_assertion :assert_rematch!, :must_rematch!, :reverse
    expectation_class.alias_method :to_rematch!, :must_rematch!
  end
end
