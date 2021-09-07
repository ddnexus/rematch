# frozen_string_literal: true

source 'https://rubygems.org'

# we cannot use gemspec here because it would load pagy before simplecov so missing files from coverage
# gemspec

gem 'minitest'
gem 'rake'
gem 'rake-manifest'

group :test do
  gem 'codecov', require: false
  gem 'minitest-reporters'
  gem 'minitest-unordered'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-packaging'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'simplecov', require: false
end
