# frozen_string_literal: true

require 'rake'

class Rematch
  module Tasks
    extend Rake::DSL
    namespace :rematch do
      desc 'Delete all the rematch stores below the tree=/path/to/test/dir (or current tree if omitted)'
      task :reset do
        pattern = Pathname.new(ENV['tree'] || '').join('**','*.rematch')
        Dir.glob(pattern).each { |f| File.delete(f) }
      end
    end
  end
end
