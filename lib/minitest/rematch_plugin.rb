# frozen_string_literal: true

require 'rematch'

# Implement the minitest plugin
module Minitest
  class Test
    def before_setup
      @rematch = Rematch.new(path: method(name).source_location.first, id: location)
      super
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
