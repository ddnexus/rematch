# frozen_string_literal: true

require_relative 'test_helper'

describe 'rematch' do
  describe 'version match' do
    it 'has version' do
      _(Rematch::VERSION).wont_be_nil
    end
    it 'defines the same version in CHANGELOG.md' do
      _(File.read('CHANGELOG.md')).must_match "## Version #{Rematch::VERSION}"
    end
    it 'defines the same version in .github/.env' do
      _(File.read('.github/.env')).must_match "VERSION=#{Rematch::VERSION}"
    end
  end
end
