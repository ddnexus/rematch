# frozen_string_literal: true

require 'yaml/store'
require 'fileutils'

# Handles the key/value store for each test
class Rematch
  VERSION = '1.4.1'
  EXT     = '.rematch'

  @rebuild = false  # rebuild the store?
  @rebuilt = []     # paths already rebuilt
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

  # Instantiated at each test, stores the path and the unique id of the test being run
  def initialize(path:, id:)
    path = "#{path}#{EXT}"
    self.class.check_rebuild(path)
    @store = YAML::Store.new(path, true)
    @id    = id
    @count = 0
  end

  # Retrieve the stored value for the current assertion if its key is known; store the value otherwise
  def rematch(value)
    key = assertion_key
    @store.transaction { |s| s.root?(key) ? s[key] : s[key] = value }
  end

  # Store the value
  def store(value)
    @store.transaction { |s| s[assertion_key] = value }
  end

  private

  # Return the key for the current assertion
  def assertion_key
    "[#{@count += 1}] #{@id}"
  end
end
