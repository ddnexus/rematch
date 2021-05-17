# frozen_string_literal: true

require 'rake/testtask'

# Collect the other tests
Rake::TestTask.new(:test) do |t|
  test_files    = FileList.new.include('test/**/*_test.rb')
  t.test_files  = test_files
  t.description = "Run tests in #{test_files.join(', ')}"
end
