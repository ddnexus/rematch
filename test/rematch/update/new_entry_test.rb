# frozen_string_literal: true

require_relative 'helper'

describe 'rematch/update/new_entry' do
  include UpdateHelper

  watch __FILE__

  it 'inserts new target between anchors' do
    assert_rematch 'anchor_top'
    expect('new_target').to_rematch
    assert_rematch 'anchor_bottom'
  end
end
