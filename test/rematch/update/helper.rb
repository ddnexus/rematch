# frozen_string_literal: true

require_relative '../../test_helper'
require 'yaml'

module UpdateHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def watch(test_path)
      store_path    = "#{test_path}#{Rematch::CONFIG[:ext]}"
      expected_path = test_path.sub('.rb', '_expected.rb.yaml')

      # Setup backup and verification
      before do
        @_store_path    = store_path
        @_original_data = File.exist?(store_path) ? File.read(store_path) : nil
        @_original_mtime = File.exist?(store_path) ? File.mtime(store_path) : nil
      end

      after do
        # 1. VERIFY
        if File.exist?(expected_path)
          # Fix: Assert on the boolean value, not the message string
          _(File.exist?(store_path)).must_equal true, 'Store file must exist'

          actual_store   = YAML.unsafe_load_file(store_path)
          expected_store = YAML.unsafe_load_file(expected_path)

          _(actual_store).must_equal expected_store

          # If content is identical to original, verify file wasn't touched (mtime check)
          if @_original_data && (YAML.unsafe_load(@_original_data) == expected_store)
            _(File.mtime(store_path)).must_equal @_original_mtime
          end
        elsif File.exist?(store_path)
          # If no expected file, we expect the store to be gone or empty
          content = YAML.unsafe_load_file(store_path)
          _(content).must_be_empty
        end

        # 2. RESTORE
        if @_original_data
          File.write(store_path, @_original_data)
          File.utime(@_original_mtime, @_original_mtime, store_path) if @_original_mtime
        else
          FileUtils.rm_f(store_path)
        end
      end
    end
  end
end
