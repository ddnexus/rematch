# frozen_string_literal: true

require 'yaml'

class Rematch
  # A simple Hash-based store that syncs with a static source map
  class Store
    attr_reader :path

    def initialize(path, source_ids)
      @path    = path
      @entries = (File.exist?(path) && YAML.unsafe_load_file(path)) || {}
      @index   = {} # Map ID => Full Key (e.g. "L11 <id>")

      # Prune dead keys and build index
      @entries.keep_if do |key, _|
        id = key.split.last
        if source_ids.include?(id)
          @index[id] = key
          true
        end
      end
    end

    # Retrieve the list of entries for a given ID, handling key renames (code moves) automatically
    def ensure(id, new_key)
      old_key = @index[id]

      if old_key && old_key != new_key
        @entries[new_key] = @entries.delete(old_key) # Rename in YAML
        @index[id]        = new_key                  # Update Index
      end

      @index[id]        ||= new_key
      @entries[new_key] ||= []
    end

    def save
      return FileUtils.rm_f(@path) if @entries.empty?

      sorted  = @entries.sort_by { |k, _| k[/\d+/].to_i }.to_h  # Sort by Line Number (extracted from key)
      content = YAML.dump(sorted, line_width: -1)
      return if File.exist?(@path) && File.read(@path) == content

      File.write(@path, content)
    end
  end
end
