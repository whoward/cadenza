module Cadenza
  # The {DocumentNode} is intended to be the root node of any parsed AST in
  # Cadenza. In addition to holding the primary children it also holds data
  # that affects the entire document, such as block definitions and the name of
  # any extended template.
  class DocumentNode
    include TreeNode

    # @return [String] the name of the template this document will inherit from
    attr_accessor :extends

    # @return [Array] any child nodes belonging to this one
    attr_accessor :children

    # @return [Hash] a mapping of any blocks defined in this document where the
    #                key is the name of the block and the value is the {BlockNode}
    #                itself
    attr_accessor :blocks

    # creates a new {DocumentNode} with the optional children nodes attached to
    # it.
    # @param [Array] children any child nodes to initially assign to this node.
    def initialize(children = [])
      @children = children
      @blocks = {}
    end

    # @param [DocumentNode] other
    # @return [Boolean] if the given {DocumentNode} is equivalent by value to this one.
    def ==(other)
      @children == other.children &&
        @extends == other.extends &&
        @blocks == other.blocks
    end

    # adds the given {BlockNode} to this document replacing any existing definition
    # of the same name.
    # @param [BlockNode] block
    def add_block(block)
      @blocks[block.name] = block
    end

    # returns a list of any global variable names implied by examining the children
    # of this node.
    # @return [Array]
    def implied_globals
      @children.map(&:implied_globals).flatten.uniq
    end
  end
end
