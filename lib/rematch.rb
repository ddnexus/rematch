# frozen_string_literal: true

require 'yaml/store'
require 'fileutils'

# Handles the key/value store for each test
class Rematch
  VERSION = '3.0.0'
  DEFAULT = { ext: '.yaml' }  # rubocop:disable Style/MutableConstant

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
    path = "#{path}#{DEFAULT[:ext]}"
    self.class.check_rebuild(path)
    @store = YAML::Store.new(path, true)
    @id    = id.tr('#: ', '_')       # easier key string for clumsy yaml parsers/highlighters
  end

  # Retrieve the stored value for the current assertion if its key is known; store the value otherwise
  def rematch(key, value)
    # key = assertion_key(key)
    @store.transaction do |s|
      if s.root?(@id)                # there is the root id
        if s[@id].key?(key)          # there is the key
          s[@id][key]                # return it
        else                         # not such a key
          s[@id][key] = value        # set
        end
      else                           # there is no root yet
        s[@id] = { key => value }    # the key is the first one
        value                        # always return the value
      end
    end
  end

  # Store the value
  def store(key, value)
    @store.transaction do |s|
      if s.root?(@id)                # there is the root id
        s[@id][key] = value          # set
      else                           # there is no root yet
        s[@id] = { key => value }    # the key is the first one
        value                        # always return the value
      end
    end
  end
end
