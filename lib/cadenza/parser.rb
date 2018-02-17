
# frozen_string_literal: true

module Cadenza
  class ParseError < Cadenza::Error
  end

  # The {Parser} class takes all tokens retrieved from it's lexer and forms them
  # into an abstract syntax tree (AST) with a {DocumentNode} at it's root.
  #
  # {Parser} and {RaccParser} are tightly coupled to each other but were separated
  # since Racc tends to generate undocumentable parser classes.
  class Parser < RaccParser
    # @return [Lexer] the lexer object this parser is using to retrieve tokens from
    attr_reader :lexer

    # creates a new {Parser} with the given options
    # @param [Hash] options
    # @option options [Lexer] :lexer (Cadenza::Lexer.new) the lexer you want this
    #         parser to retrieve tokens from.
    # @raise  [RuntimeError] if the given lexer doesn't respond to :next_token and :source=
    def initialize(options = {})
      @lexer = options.fetch(:lexer, Cadenza::Lexer.new)

      raise 'Lexers passed to the parser must define next_token' unless @lexer.respond_to?(:next_token)

      raise 'Lexers passed to the parser must define source=' unless @lexer.respond_to?(:source=)
    end

    # takes the given source object and parses tokens from it, the tokens are
    # then constructed into an abstract syntax tree (AST) with a {DocumentNode}
    # at the root.  The root node is then returned.
    #
    # @param [String] source the template text to parse
    # @return [DocumentNode] the root node of the parsed AST
    # @raise [ParseError] if the given template does not have a valid syntax
    def parse(source)
      @lexer.source = source

      @stack = [DocumentNode.new]
      @namespaces = []

      do_parse

      @stack.first
    end

    private

    def document
      @stack.first
    end

    # this is a handy method to add a node to the AST properly, it's used in
    # the cadenza.y file
    def push(node)
      @stack.first.add_block(node) if node.is_a?(BlockNode)

      @stack.last.children.push(node)
    end

    def open_scope!
      @stack.push DocumentNode.new
    end

    def close_scope!
      @stack.pop.children
    end

    def open_block_scope!(name)
      @namespaces.push(name)
      open_scope!
      @namespaces.join('.')
    end

    def close_block_scope!
      @namespaces.pop
      close_scope!
    end

    # this is the method Racc will call to get the next token in the stream
    def next_token
      @lexer.next_token
    end

    # this is Racc's callback for a parse error
    def on_error(error_token_id, error_value, _value_stack)
      token = token_to_str(error_token_id)
      value = error_value

      line, column = value ? [value.line, value.column] : [nil, nil]

      # use the stringified token to try to get as informative and human an error
      # message as possible for us to raise.
      #
      # To contributors: if you get an uninformative error message please let me know so I can improve this!
      msg =
        case token
        when '$end' then 'unexpected end of input'
        else "unexpected token #{value.source.inspect} at line #{line.inspect}, column #{column.inspect}"
        end

      raise ParseError, msg
    end
  end
end
