module Cadenza
  # The {InjectNode} is intended to write the given variable into the rendered
  # output by evaluating it in the given {Context} and passing it through an
  # optional series of {FilterNode}s.
  class InjectNode
    # @return [VariableNode|OperationNode|BooleanInverseNode|ConstantNode] the value being evaluated
    attr_accessor :value

    # creates a new {InjectNode} with the given value, filters and parameters
    # @param [VariableNode|OperationNode|BooleanInverseNode|ConstantNode] value see {#value}
    def initialize(value)
      @value = value
    end

    # @param [InjectNode] rhs
    # @return [Boolean] true if the given InjectNode is equivalent by value to this node.
    def ==(rhs)
      self.value == rhs.value
    end

    # @return [Array] a list of variable names implied to be global by this node
    def implied_globals
      @value.implied_globals
    end

    # @param [Context] context
    # @return [String] returns the evaluated {#value} of this node
    def evaluate(context)
      @value.eval(context)
    end
  end
end