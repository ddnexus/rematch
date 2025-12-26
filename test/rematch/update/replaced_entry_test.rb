# frozen_string_literal: true

require_relative 'helper'

describe 'rematch/update/replaced_entry' do
  include UpdateHelper

  watch __FILE__

  it 'updates replaced target value' do
    assert_rematch 'anchor_top'
    assert_rematch 'new_value'
    assert_rematch 'anchor_bottom'
  end
end
