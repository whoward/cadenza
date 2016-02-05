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

    MAGIC_LOCALS = %w(forloop.counter forloop.counter0 forloop.first forloop.last).freeze

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

    # @return [Array] of all global variable names defined by this node and
    #                 it's child nodes.
    def implied_globals
      iterable_globals = @iterable.implied_globals
      iterator_globals = @iterator.implied_globals

      iterator_regex = Regexp.new("^#{@iterator.identifier}[\.](.+)$")

      all_children_globals = @children.map(&:implied_globals).flatten

      children_globals = all_children_globals.reject { |x| x =~ iterator_regex }

      iterator_children_globals = all_children_globals.select { |x| x =~ iterator_regex }.map do |identifier|
        "#{iterable.identifier}.#{iterator_regex.match(identifier)[1]}"
      end

      (iterable_globals | children_globals | iterator_children_globals) - MAGIC_LOCALS - iterator_globals
    end

    # @param [ForNode] rhs
    # @return [Boolean] true if the given {ForNode} is equivalent by value to
    #                   this node.
    def ==(rhs)
      @iterator == rhs.iterator &&
        @iterable == rhs.iterable &&
        @children == rhs.children
    end
  end
end
