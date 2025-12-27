# frozen_string_literal: true

require 'ripper'
require 'digest/sha1'

class Rematch
  # Parses a Ruby source file to statically identify the content of every line.
  class Source
    attr_reader :index

    REMATCH_METHODS = %w[assert_rematch store_assert_rematch
                         must_rematch to_rematch store_must_rematch store_to_rematch].freeze
    IGNORED_TOKENS  = (REMATCH_METHODS + %w[expect value _]).freeze
    DOT_TOKENS      = ['.', '&.'].freeze
    SKIP_TYPES      = %i[on_comment on_sp on_nl on_ignored_nl].freeze

    def initialize(source)
      @index = Hash.new { |h, k| h[k] = [] } # { lineno => [id1, id2, ...] }

      source.lines.each_with_index do |line, i|
        lineno = i + 1
        tokens = tokenize(line)
        next if tokens.empty?

        @index[lineno] << Digest::SHA1.hexdigest(tokens.join)
      end
    end

    private

    def tokenize(line)
      raw_tokens = Ripper.lex(line).reject { |t| SKIP_TYPES.include?(t[1]) }

      [].tap do |tokens|
        raw_tokens.each_with_index do |t, i|
          token = t[2]
          if DOT_TOKENS.include?(token)
            next_token = raw_tokens[i + 1]
            next if next_token && REMATCH_METHODS.include?(next_token[2]) # Ignore dot if rematch
          end
          next if IGNORED_TOKENS.include?(token)

          tokens << token
        end
      end
    end
  end
end
