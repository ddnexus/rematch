# frozen_string_literal: true

require 'yaml/store'
require 'fileutils'

# Implement the key/value store
class Rematch
  VERSION = '1.3.0'
  EXT     = '.rematch'

  @rebuild = false
  @rebuilt = []
  class << self
    attr_accessor :rebuild

    def check_rebuild(path)
      return unless @rebuild && !@rebuilt.include?(path)

      FileUtils.rm_f(path)
      @rebuilt << path
      puts "Rebuilt #{path}"
    end
  end

  # path and unique id of the test being run
  def initialize(path:, id:)
    path = "#{path}#{EXT}"
    self.class.check_rebuild(path)
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
