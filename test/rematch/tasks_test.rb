# frozen_string_literal: true

require_relative '../test_helper'
require 'fileutils'


describe 'rematch/tasks' do
  before do
    FileUtils.mkdir_p 'test/tree/branch'
    FileUtils.touch %w[test/tree/one.rematch test/tree/branch/two.rematch]
  end
  after do
    ENV['tree'] = nil
    FileUtils.rmtree 'test/tree'
  end

  describe 'can delete rematch stores' do
    it 'deletes current tree' do
      FileUtils.cd('test/tree') do
        Rake::Task['rematch:reset'].execute
        _(File.file?('test/tree/one.rematch')).must_equal false
        _(File.file?('test/tree/branch/two.rematch')).must_equal false
      end
    end
    it 'deletes specific tree' do
      ENV['tree'] = 'test/tree'
      Rake::Task['rematch:reset'].execute
      _(File.file?('test/tree/one.rematch')).must_equal false
      _(File.file?('test/tree/branch/two.rematch')).must_equal false
    end
    it 'deletes specific branch' do
      ENV['tree'] = 'test/tree/branch'
      Rake::Task['rematch:reset'].execute
      _(File.file?('test/tree/one.rematch')).must_equal true
      _(File.file?('test/tree/branch/two.rematch')).must_equal false
    end
  end
end
