# frozen_string_literal: true

require_relative 'helper'

describe 'rematch/update/unchanged_entry' do
  include UpdateHelper

  watch __FILE__

  it 'keeps all entries unchanged' do
    assert_rematch 'anchor_top'
    assert_rematch 'target_val'
    assert_rematch 'anchor_bottom'
  end
end
