# frozen_string_literal: true

require 'ripper'
require 'digest/sha1'

class Rematch
  # Parses a Ruby source file to statically identify the context (path) and content of every line.
  class Source
    attr_reader :index

    REMATCH_METHODS = %w[assert_rematch store_assert_rematch
                         must_rematch to_rematch store_must_rematch store_to_rematch].freeze
    IGNORED_TOKENS  = (REMATCH_METHODS + %w[expect value _]).freeze
    DOT_TOKENS      = ['.', '&.'].freeze

    def initialize(source)
      @source   = source
      @lines    = source.lines
      @index    = Hash.new { |h, k| h[k] = [] } # { lineno => [id1, id2, ...] }
      @context  = [] # Context stack
      @contexts = {} # { lineno => context_array }
      if (sexp = Ripper.sexp(@source))
        walk(sexp)
        build_index
      end
    end

    private

    def walk(node)
      return unless node.is_a?(Array)

      if (lineno = extract_line(node))
        @contexts[lineno] ||= @context.dup
      end
      case node.first
      when :class, :module
        name = extract_name(node[1])
        @context.push(name)
        walk(node.last)
        @context.pop
      when :def
        name = node[1][1]
        @context.push(name)
        walk(node[3]) # body
        @context.pop
      when :method_add_block
        handle_block(node)
      else
        node.each { |child| walk(child) }
      end
    end

    def handle_block(node)
      call_node   = node[1]
      block_node  = node[2]
      method_name = extract_method_name(call_node)
      if %w[describe context it specify].include?(method_name)
        description = extract_arg_string(call_node)
        @context.push(description)
        walk(block_node)
        @context.pop
      else
        walk(call_node)
        walk(block_node)
      end
    end

    def build_index
      @lines.each_with_index do |line_content, i|
        lineno = i + 1
        tokens = tokenize(line_content)
        next if tokens.empty?

        context = @contexts[lineno] || [] # Use recorded context or fallback to empty (top-level)
        @index[lineno] << Digest::SHA1.hexdigest("#{context.join('/')}#{tokens}")
      end
    end

    def tokenize(line_content)
      raw_tokens = Ripper.lex(line_content).reject { |t| t[1] == :on_comment || t[1] =~ /sp|nl/ }
      tokens     = []
      raw_tokens.each_with_index do |t, i|
        token = t[2]
        if DOT_TOKENS.include?(token)
          next_token = raw_tokens[i + 1]
          next if next_token && REMATCH_METHODS.include?(next_token[2]) # Ignore dot if rematch
        end
        next if IGNORED_TOKENS.include?(token)

        tokens << token
      end
      tokens.join
    end

    # --- Extractors ---

    def extract_line(node)
      # Terminals like [:@ident, "name", [line, col]]
      node.last[0] if node.first.is_a?(Symbol) &&
                      node.first.to_s.start_with?('@') &&
                      node.last.is_a?(Array) &&
                      node.last.size == 2
    end

    def extract_name(node)
      return '' unless node.is_a?(Array)

      case node.first
      when :const_path_ref then "#{extract_name(node[1])}::#{extract_name(node[2])}"
      when :var_ref, :const_ref then extract_name(node[1])
      when :call then "#{extract_name(node[1])}.#{extract_name(node[3])}"
      when :@const, :@ident, :@op then node[1]
      else 'Unknown'
      end
    end

    def extract_method_name(node)
      return nil unless node.is_a?(Array)

      case node.first
      when :command, :fcall then node[1][1]
      when :call, :command_call then node[3][1]
      when :method_add_arg, :method_add_block then extract_method_name(node[1])
      end
    end

    def extract_arg_string(node)
      args_node = case node.first
                  when :command, :command_call then node[2]
                  when :method_add_arg, :method_add_block then node[1][2]
                  end

      return 'anonymous' if args_node.nil? || args_node.empty?

      args_list = args_node.first == :args_add_block ? args_node[1] : args_node
      return 'anonymous' if args_list.nil? || args_list.empty?

      arg = args_list.first
      return 'anonymous' unless arg

      case arg.first
      when :string_literal
        content_node = arg[1]
        if content_node&.first == :string_content
          content_node[1..].map { |p| p[1] if p.is_a?(Array) && p.first == :@tstring_content }.join
        else
          ''
        end
      when :symbol_literal
        begin
          arg[1][1][1]
        rescue StandardError
          'unknown_sym'
        end
      else extract_name(arg)
      end
    rescue StandardError
      'unknown_arg'
    end
  end
end
