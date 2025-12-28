# frozen_string_literal: true

require_relative 'rematch/store'
require_relative 'rematch/source'

# Add description
class Rematch
  VERSION = '5.0.0'
  CONFIG  = { ext: '.yaml' }.freeze

  class << self
    attr_accessor :rebuild, :skip_warning

    def stores = @stores ||= {}
  end

  attr_reader :forced

  def initialize(test)
    @test    = test
    @file,   = test.method(test.name).source_location
    @store   = self.class.stores[@file] ||=
               begin # rubocop:disable Layout/AssignmentIndentation
                 path = "#{@file}#{CONFIG[:ext]}"
                 File.delete(path) if self.class.rebuild && File.exist?(path)
                 Store.new(path, Source.new(File.read(@file)).index)
               end
    @session = Hash.new { |h, k| h[k] = [] }
    @counts  = Hash.new(0)
    @forced  = []
  end

  def rematch(actual, force: false)
    # Identify the assertion line by walking up the stack until we find the test file
    location = caller_locations.find { |l| l.path == @file }
    raise "Could not find assertion in #{@file}" unless location

    sha = @store.sha_at(location.lineno)
    raise "No rematch assertion found at line #{location.lineno}" unless sha

    # Record value for this session
    @session[sha] << actual
    index         = @counts[sha]
    @counts[sha] += 1
    @forced << "#{location.path}:#{location.lineno}" if force
    # Determine return value
    return actual if force || self.class.rebuild

    stored = @store.get(sha)
    return stored[index] if stored && index < stored.size

    warn "[rematch] Stored new value for #{location}" unless self.class.skip_warning
    actual
  end

  def save
    # Only save if the test passed to avoid corrupting the store with partial runs
    return unless @test.failures.empty?

    @session.each { |sha, values| @store.update(sha, values) }
    @store.save
  end
end
