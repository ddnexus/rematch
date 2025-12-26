# frozen_string_literal: true

require_relative 'helper'

describe 'rematch/update/moved_entry' do
  include UpdateHelper

  watch __FILE__

  it 'updates moved target and shifts bottom' do
    assert_rematch 'anchor_top'
    # Filler to force line number change relative to start store

    expect('moved_target').to_rematch
    assert_rematch 'anchor_bottom'
  end
end
