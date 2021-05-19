# frozen_string_literal: true

require 'yaml/store'
require 'fileutils'

# Implement the key/value store
class Rematch
  VERSION = '1.0'
  EXT     = '.rematch'

  @refreshed = []
  class << self
    attr_accessor :refresh

    def check_refresh(path)
      return unless @refresh && !@refreshed.include?(path)
      FileUtils.rm_f(path)
      @refreshed << path
      puts "Refresh #{path}"
    end
  end

  # path and unique id of the test being run
  def initialize(path:, id:)
    path = "#{path}#{EXT}"
    self.class.check_refresh(path)
    @store = YAML::Store.new(path, true)
    @id    = id
    @count = 0
  end

  # store if unknown; retrieve otherwise
  def rematch(value)
    key = "[#{@count += 1}] #{@id}"
    @store.transaction { |s| s.root?(key) ? s[key] : s[key] = value }
  end
end
