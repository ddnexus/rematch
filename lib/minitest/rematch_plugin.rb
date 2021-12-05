# frozen_string_literal: true

require 'rematch'

# Implement the minitest plugin
module Minitest
  def self.plugin_rematch_options(opts, _options)
    opts.on '--rematch-rebuild', 'Rebuild the stores with the current entries/values' do
      Rematch.rebuild = true
    end
  end

  # Reopen the minitest class
  class Test
    def before_setup
      super
      @rematch = Rematch.new(path: method(name).source_location.first, id: location)
    end
  end

  # Reopen the minitest module
  module Assertions
    def assert_rematch(actual, *args)
      assertion = :assert_equal
      message   = nil
      args.each { |arg| arg.is_a?(Symbol) ? assertion = arg : message = arg }
      send assertion, @rematch.rematch(actual), actual, message  # assert that the stored value is the same
    end
  end

  # Reopen the minitest module
  module Expectations
    infect_an_assertion :assert_rematch, :must_rematch, true # dont_flip
  end
end
