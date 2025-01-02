# frozen_string_literal: true

require 'fileutils'
require_relative 'rematch/store'

# Handles the key/value store for each test
class Rematch
  VERSION = '3.2.0'
  CONFIG  = { ext: '.yaml' }  # rubocop:disable Style/MutableConstant

  @rebuild      = false  # rebuild the store?
  @rebuilt      = []     # paths already rebuilt
  @skip_warning = false

  class << self
    attr_accessor :rebuild, :skip_warning

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
    store_path = "#{path}#{CONFIG[:ext]}"
    self.class.check_rebuild(store_path)
    @store = Store.new(store_path, true)
    @id    = id.tr('#: ', '_')       # easier key string for clumsy yaml parsers/highlighters
  end

  # Retrieve the stored value for the current assertion if its key is known; store the value otherwise
  def rematch(key, value, overwrite: nil)
    # key = assertion_key(key)
    @store.transaction do |s|
      if s.root?(@id)                     # there is the root id
        if s[@id].key?(key) && !overwrite # there is the key and not overwrite
          s[@id][key]                     # return it
        else                              # not such a key
          s[@id][key] = value             # set it
          store_warning(key) unless overwrite
          value
        end
      else                                # there is no root yet
        s[@id] = { key => value }         # the key is the first one
        store_warning(key)
        value                             # always return the value
      end
    end
  end

  def store_warning(key)
    warn "Rematch stored new value for: #{key.inspect}\n#{@id}\n#{@store.path}\n\n" \
          unless Rematch.skip_warning
  end
end
