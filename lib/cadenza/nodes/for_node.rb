# frozen_string_literal: true

module Cadenza
  # The {ForNode} describe a loop in the template code.  The loop should iterate
  # over all the elements of the iterable and render its children each time.
  class ForNode
    include TreeNode

    # @return [VariableNode] the iterator object for the loop
    attr_accessor :iterator

    # @return [VariableNode] the iterable object for the loop
    attr_accessor :iterable

    # @return [Array] the list of children associated with this loop
    attr_accessor :children

    # constructs a new {ForNode} with the given iterator, iterable and child
    # nodes.
    # @param [VariableNode] iterator the iterator object for the loop
    # @param [VariableNode] iterable the iterable object for the loop
    # @param [Array] children the list of children associated with this loop
    def initialize(iterator, iterable, children)
      @iterator = iterator
      @iterable = iterable
      @children = children
    end

    # @param [ForNode] other
    # @return [Boolean] true if the given {ForNode} is equivalent by value to
    #                   this node.
    def ==(other)
      @iterator == other.iterator &&
        @iterable == other.iterable &&
        @children == other.children
    end
  end
end
