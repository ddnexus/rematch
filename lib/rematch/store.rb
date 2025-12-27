# frozen_string_literal: true

require 'yaml'

class Rematch
  # A simple Hash-based store that syncs with a static source map
  class Store
    attr_reader :path

    def initialize(path, source_ids)
      @path    = path
      @entries = (File.exist?(path) && YAML.unsafe_load_file(path)) || {}
      @index   = Hash.new { |h, k| h[k] = [] }

      # Prune dead keys and build index
      @entries.keep_if do |key, _|
        id = id_from(key)
        if source_ids.include?(id)
          @index[id] << key
          true
        end
      end

      # Order the index queues by lineno to ensure FIFO claiming
      @index.each_value { |keys| keys.sort_by! { |k| order_by_lineno(k) } }
    end

    def keys(id) = @index[id]

    def delete(key)
      value = @entries.delete(key) # Capture the value
      @index[id_from(key)].delete(key)
      value # Return the value
    end

    def [](key) = @entries[key]

    def []=(key, value)
      @entries[key] = value
      id = id_from(key)
      # Keep index in sync and sorted
      return if @index[id].include?(key)

      @index[id] << key
      @index[id].sort_by! { |k| order_by_lineno(k) }
    end

    def save
      return FileUtils.rm_f(@path) if @entries.empty?

      sorted  = @entries.sort_by { |k, _| order_by_lineno(k) }.to_h
      content = YAML.dump(sorted, line_width: -1)
      return if File.exist?(@path) && File.read(@path) == content  # Return if unchanged (preserves mtime)

      File.write(@path, content)
    end

    private

    def id_from(key) = key.split.last

    # Order by L<num> and .<count> suffix
    def order_by_lineno(key)
      match = key.match(/L(\d+)(?:\.(\d+))?/)
      [match[1].to_i, match[2].to_i]
    end
  end
end
