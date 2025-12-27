# frozen_string_literal: true

module ExternalHelper
  # Wrapper with a loop
  def check_external_loop
    %w[ext_1 ext_2].each do |item|
      assert_rematch item
    end
  end

  # Simple wrapper
  def check_external_value(val)
    assert_rematch val
  end
end
