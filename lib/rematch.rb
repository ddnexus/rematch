# frozen_string_literal: true

require 'yaml/store'
require 'rematch/tasks'

# Implement the key/value store
class Rematch
  VERSION = '0.0.1'
  EXT     = '.rematch'

  # path and unique id of the test being run
  def initialize(path:, id:)
    @store = YAML::Store.new("#{path}#{EXT}", true)
    @id    = id
    @count = 0
  end

  # store if unknown; retrieve otherwise
  def rematch(value)
    key = "[#{@count += 1}] #{@id}"
    @store.transaction { |s| s.root?(key) ? s[key] : s[key] = value }
  end
end
