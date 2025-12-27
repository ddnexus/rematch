# frozen_string_literal: true

require_relative '../test_helper'
require_relative 'support/external_helper'

describe 'rematch/scenarios' do
  include ExternalHelper

  it 'handles loops with explicit labels' do
    %w[a b].each do |item|
      assert_rematch item, label: 'loop_1'
    end
  end

  it 'handles optional description labels' do
    # Label used just for documentation/clarity
    assert_rematch 'single_value', label: 'just_checking'
  end

  it 'handles external wrappers (simple)' do
    # This line (L21) calls a helper that calls assert_rematch
    # Rematch should key this off L21
    check_external_value 'simple_ext'
  end

  it 'handles external wrappers (loop)' do
    # This line (L27) calls a helper that loops 2 times
    # Rematch should see L27 called twice and create L27, L27.2
    check_external_loop
  end

  it 'handles loops with line number changes (reconciliation)' do
    values   = %w[move_1 move_2]
    run_loop = lambda do
      values.each do |val|
        assert_rematch val, label: 'move_loop'
      end
    end

    # Setup store with moved keys to simulate code movement
    path   = __FILE__
    env    = Rematch.environment(path)
    lineno = File.readlines(path).index { |l| l.include?("label: 'move_loop'") } + 1
    id     = env[:source].index[lineno].first
    store  = env[:store]

    # Seed fake old keys and clear current ones to force reconciliation
    # We access internals because the public API no longer allows setting arbitrary keys
    entries = store.instance_variable_get(:@entries)
    index   = store.instance_variable_get(:@index)

    entries["L9999 #{id}"] = [{ 'move_loop' => 'move_1' }, { 'move_loop' => 'move_2' }]
    index[id] = "L9999 #{id}"

    # Ensure the current line key doesn't exist
    entries.delete("L#{lineno} #{id}")

    run_loop.call
  end
end
