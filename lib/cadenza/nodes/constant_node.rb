module Cadenza
  # The {ConstantNode} holds a value which is not affected by any context given
  # to it, such as numbers or strings.
  class ConstantNode
    include TreeNode

    # @return [Object] the value of this node
    attr_accessor :value

    # constructs a new {ConstantNode} with the given value.
    # @param [Object] value the value of this constant node
    def initialize(value)
      @value = value
    end

    # @param [Context] context
    # @return [Object] the value of this node evaluated in the given context
    def eval(_context)
      @value
    end

    # @param [ConstantNode] other
    # @return [Boolean] if this node and the given one are equivalent by value
    def ==(other)
      @value == other.value
    end
  end
end
