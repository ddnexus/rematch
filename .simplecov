# frozen_string_literal: true

SimpleCov.start do
  SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter unless ENV['CI'] || ENV['COVERAGE_REPORT'] == 'true'
  SimpleCov.command_name "Task##{$PROCESS_ID}"
  SimpleCov.merge_timeout 20
end
