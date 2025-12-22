# frozen_string_literal: true

require_relative 'helper'

describe 'rematch/update/orphan_entry' do
  include UpdateHelper

  watch __FILE__

  it 'removes missing target' do
    assert_rematch 'anchor_top'
    assert_rematch 'anchor_bottom'
  end
end
