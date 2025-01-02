# frozen_string_literal: true

require 'yaml/store'

class Rematch
  # Subclass of YAML::Store
  class Store < YAML::Store
    # Use unsafe load, because tests are trusted content
    def load(content)
      YAML.unsafe_load(content) || {}
    end
  end
end
