
# frozen_string_literal: true

module Cadenza
  # The {FilteredValueNode} applies a list of passed {FilterNode} to it's value
  # when evaluated.
  class FilteredValueNode
    include TreeNode

    # @return [Node] the value to be filtered
    attr_accessor :value

    # @return [Array] a list of {FilterNode} to evaluate the value with, once the
    #                 value has itself been evaluated.
    attr_accessor :filters

    # creates a new {FilteredValueNode}.
    # @param [String] value see {#value}
    # @param [Array] filters see {#filters}
    def initialize(value, filters = [])
      @value = value
      @filters = filters
    end

    # @param [Context] context
    # @return [Object] gets the value and returns it after being passed
    #                  through all filters
    def eval(context)
      value = @value.eval(context)

      @filters.each { |filter| value = filter.evaluate(context, value) }

      value
    end

    # @param [FilteredValueNode] other
    # @return [Boolean] if the given {FilteredValueNode} is equivalent by
    #                   value to this node.
    def ==(other)
      value == other.value && filters == other.filters
    end
  end
end
