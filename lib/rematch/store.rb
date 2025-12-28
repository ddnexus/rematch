# frozen_string_literal: true

require 'yaml'
require 'fileutils'

class Rematch
  # A simple Hash-based store that syncs with a static source map
  class Store
    attr_reader :path

    def initialize(path, source_index)
      @path         = path
      @source_index = source_index # { line_integer => [sha_string] }
      @entries      = (File.exist?(path) && YAML.unsafe_load_file(path)) || {}
      @index        = {} # Map ID => Full Key (e.g. "L11 <id>")

      # Prune dead keys and build index
      valid_shas = source_index.values.flatten.uniq
      @entries.keep_if do |key, _|
        id = key.split.last
        if valid_shas.include?(id)
          @index[id] = key
          true
        end
      end
    end

    def sha_at(line) = @source_index[line]&.first
    def get(id)      = @entries[@index[id]]

    # Overwrite the entry for a given ID with a new list of values
    def update(id, values)
      # Always ensure the key reflects the current line number
      line    = @source_index.find { |_, shas| shas.include?(id) }&.first
      new_key = "L#{line} #{id}"
      old_key = @index[id]
      if old_key && old_key != new_key
        @entries.delete(old_key)
      end

      @index[id]        = new_key
      @entries[new_key] = values
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
