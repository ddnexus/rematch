# frozen_string_literal: true

require 'rematch'

# Implement the minitest plugin
module Minitest
  def self.plugin_rematch_options(opts, _options)
    opts.on '--rematch-refresh-only', 'ONLY Refresh the stored values with the current values' do
      Rematch.refresh = true
    end
  end
  class Test
    def before_setup
      super
      @rematch = Rematch.new(path: method(name).source_location.first, id: location)
    end
  end
  module Assertions
    def assert_rematch(_expected, actual)
      assert_equal(@rematch.rematch(actual), actual)
    end
  end
  module Expectations
    infect_an_assertion :assert_rematch, :must_rematch
  end
end
