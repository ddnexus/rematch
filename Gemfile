# frozen_string_literal: true

source 'https://rubygems.org'

# we cannot use gemspec here because it would load rematch before simplecov so missing files from coverage
# gemspec

gem 'rake'

group :development do
  gem 'debase'         # companion of ruby-debug-ide
  gem 'ruby-debug-ide' # companion of debase
end

group :test do
  gem 'codecov', require: false
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'minitest-unordered'
  gem 'rake-manifest'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-packaging'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'simplecov', require: false
end
