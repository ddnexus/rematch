# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# we cannot use gemspec here because it would load rematch before simplecov so missing files from coverage
# gemspec
gem 'mutex_m'
gem 'rake'
gem 'rake-manifest'
gem 'readline-ext' # temporary fix for RM 3.3.2 console with ruby >= 3.3.0

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'minitest-unordered'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-packaging'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'simplecov', require: false
end
