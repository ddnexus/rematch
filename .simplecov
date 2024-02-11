# frozen_string_literal: true

SimpleCov.formatter = if ENV['HTML_REPORTS'] == 'true'
                        SimpleCov::Formatter::HTMLFormatter
                      else
                        SimpleCov::Formatter::SimpleFormatter
                      end

SimpleCov.start do
  command_name "Task##{$PROCESS_ID}"  # best way to get a different id for the specific task
  merge_timeout 60
  enable_coverage :branch
end
