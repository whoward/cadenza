
module Cadenza
  # The {FilterNode} is a node which contains the definition for a variable
  # filter along with any parameters it is defined with.
  class FilterNode
    include TreeNode

    # @return [String] the name of the filter
    attr_accessor :identifier

    # @return [Array] a list of parameter nodes given to the filter
    attr_accessor :parameters

    # constructs a new {FilterNode} with the given identifier and parameters
    # @param [String] identifier the name of the filter
    # @param [Array] parameters the parameters given to the filter
    def initialize(identifier, parameters = [])
      @identifier = identifier
      @parameters = parameters
    end

    # @param [FilterNode] other
    # @return [Boolean] true if the given filter node is equivalent by value to
    #                   this node.
    def ==(other)
      @identifier == other.identifier &&
        @parameters == other.parameters
    end

    # evaluates the filter with the given context and input value and returns
    # the output of the evaluation.
    #
    # @param [Context] context the context to evaluate with
    # @param [String] value the input value to filter
    # @return the input value when passed through this evaluated filter
    def evaluate(context, value)
      context.evaluate_filter(@identifier, value, @parameters.map { |x| x.eval(context) })
    end
  end
end
