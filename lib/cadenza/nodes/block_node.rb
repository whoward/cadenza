module Cadenza
  # The {BlockNode} is a general container with a given name meant to implement
  # Cadenza's template inheritance feature.  Blocks defined in a template will
  # override the definition of blocks defined in the parent template.
  class BlockNode
    include TreeNode

    # @return [String] the name of the node
    attr_accessor :name

    # @return [Array] the child nodes belonging to this block
    attr_accessor :children

    # creates a new block node with the given name and child nodes
    # @param [String] name the name for this block node
    # @param [Array] children the child nodes belonging to this block node
    def initialize(name, children = [])
      @name = name
      @children = children
    end

    # @return [Array] a list of any implied global variable names defined by
    #                 this block's children.
    def implied_globals
      @children.map(&:implied_globals).flatten.uniq
    end

    # @param [BlockNode] rhs
    # @return [Boolean] true if the given {BlockNode} is equivalent to the this
    #                   node by value.
    def ==(rhs)
      @name == rhs.name &&
        @children == rhs.children
    end
  end
end
