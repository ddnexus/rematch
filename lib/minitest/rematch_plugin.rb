# frozen_string_literal: true

require 'rematch'

# Implement the minitest plugin
module Minitest
  def self.plugin_rematch_options(opts, _options)
    opts.on '--rematch-rebuild', 'Rebuild the stores with the current entries/values' do
      Rematch.rebuild = true
    end
  end

  # reopen the minitest class
  class Test
    def before_setup
      super
      @rematch = Rematch.new(path: method(name).source_location.first, id: location)
    end
  end

  # reopen the minitest module
  module Assertions
    def assert_rematch(actual, assert_method = :assert_equal)
      send assert_method, @rematch.rematch(actual), actual
    end
  end

  # reopen the minitest module
  module Expectations
    infect_an_assertion :assert_rematch, :must_rematch, true # dont_flip
  end
end
