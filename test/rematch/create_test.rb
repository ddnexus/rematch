# frozen_string_literal: true

require_relative '../test_helper'

describe 'rematch/create' do

  describe 'create file and entry' do
    store_file = "#{__FILE__}#{Rematch::EXT}"
    it 'creates file' do
      File.delete(store_file) if File.file?(store_file)
      _('a new value').must_rematch
      _(File.file?(store_file)).must_equal true
    end
    it 'creates an entry' do
      _(YAML.load_file(store_file)).must_equal({"[1] rematch/create::create file and entry#test_0001_creates file"=>"a new value"})
    end
  end
end
