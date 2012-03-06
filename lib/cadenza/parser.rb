
module Cadenza
# The {RaccParser} is a superclass to {Parser} which contains all the LALR parser
# rules for that class.  It was separated from {Parser} so that {Parser} could
# actually be documented - Racc's current version uses a lot of metaprogramming
# which confuses YARD.

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
    def initialize(options={})
      @lexer = options.fetch(:lexer, Cadenza::Lexer.new)

      raise "Lexers passed to the parser must define next_token" unless @lexer.respond_to?(:next_token)

      raise "Lexers passed to the parser must define source=" unless @lexer.respond_to?(:source=)
    end

    # takes the given source object and parses tokens from it, the tokens are
    # then constructed into an abstract syntax tree (AST) with a {DocumentNode}
    # at the root.  The root node is then returned.
    #
    # @param [String] source the template text to parse
    # @return [DocumentNode] the root node of the parsed AST
    def parse(source)
      @lexer.source = source

      @stack = [DocumentNode.new]

      do_parse

      @stack.first
    end

  private

    def push_child(node)
      @stack.last.children.push(node)
    end

    def push_block(block_node)
      @stack.first.add_block(block_node)
      push_child(block_node)
    end

    def next_token
      @lexer.next_token
    end
  end
end