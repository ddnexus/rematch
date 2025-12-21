# frozen_string_literal: true

require 'fileutils'
require 'digest/sha1'
require_relative 'rematch/store'

# Handles the key/value store for each test
class Rematch
  VERSION = '4.1.0'
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
  def initialize(test)
    @path      = test.method(test.name).source_location.first
    store_path = "#{@path}#{CONFIG[:ext]}"
    self.class.check_rebuild(store_path)
    @store     = Store.new(store_path, true)
    @id        = test_uid(test.class.name, test.name)
  end

  # Retrieve the stored value for the current assertion if its key is known; store the value otherwise
  def rematch(value, overwrite: nil, id: nil)
    key = assertion_key(id)
    @store.transaction do |s|
      if s.root?(key) && !overwrite       # there is the key and not overwrite
        s[key]                            # return it
      else                                # no such key or overwrite
        s[key] = value                    # set it
        tidy_store(s)                     # sort keys and cleanup orphans
        store_warning(key) unless overwrite
        value
      end
    end
  end

  def store_warning(key)
    warn "Rematch stored new value for: #{key.inspect}\n#{@store.path}\n\n" unless Rematch.skip_warning
  end

  protected

  # Generate the unique id for the test (SHA1)
  def test_uid(class_name, method_name)
    Digest::SHA1.hexdigest("#{class_name}#{method_name}")
  end

  private

  # Generate the key based on the line number, optional id, and test ID
  def assertion_key(id)
    line = caller_locations.find { |l| l.path == @path }&.lineno
    %(L#{line}#{" [#{id}]" if id} #{@id})
  end

  # Ensure the keys are sorted by the order of the tests in the file
  # and remove keys that do not match any existing test (orphans)
  def tidy_store(store)
    # Optimization: only if Minitest is loaded
    return unless defined?(Minitest::Runnable)

    # Get all valid SHA1s from all runnables in this file
    valid_ids = []
    Minitest::Runnable.runnables.each do |runnable|
      runnable.runnable_methods.each do |method_name|
        file, = runnable.instance_method(method_name).source_location
        next unless file == @path # @path is the test file path

        valid_ids << test_uid(runnable.name, method_name)
      end
    end
    # Extract all data
    data = store.roots.to_h { |key| [key, store.delete(key)] }
    # Re-add data in the correct order, filter orphans, and sort
    data.select { |key, _| valid_ids.include?(key.split.last) }
        .sort_by { |key, _| key[/L(\d+)/, 1].to_i }
        .each { |key, value| store[key] = value }
  end
end
