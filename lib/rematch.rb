# frozen_string_literal: true

require 'yaml/store'
require 'fileutils'

# Implement the key/value store
class Rematch
  VERSION = '1.4.0'
  EXT     = '.rematch'

  @rebuild = false
  @rebuilt = []
  class << self
    attr_accessor :rebuild

    # Check whether path requires rebuild and do it if required
    def check_rebuild(path)
      return unless @rebuild && !@rebuilt.include?(path)

      FileUtils.rm_f(path)
      @rebuilt << path
      puts "Rebuilt #{path}"
    end
  end

  # Path and unique id of the test being run
  def initialize(path:, id:)
    path = "#{path}#{EXT}"
    self.class.check_rebuild(path)
    @store = YAML::Store.new(path, true)
    @id    = id
    @count = 0
  end

  # Retrieve the stored value if the key is known; store the value otherwise
  def rematch(value)
    key = count_key
    @store.transaction { |s| s.root?(key) ? s[key] : s[key] = value }
  end

  def store(value)
    @store.transaction { |s| s[count_key] = value }
  end

  private

  def count_key
    "[#{@count += 1}] #{@id}"
  end
end
