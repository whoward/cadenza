module Cadenza
  # The {InjectNode} is intended to write the given variable into the rendered
  # output by evaluating it in the given {Context} and passing it through an
  # optional series of {FilterNode}s.
  class InjectNode
    # @return [VariableNode|OperationNode|BooleanInverseNode|ConstantNode] the value being evaluated
    attr_accessor :value

    # @return [Array] a list of {FilterNode} to evaluate the value with, once the
    #                 value has itself been evaluated.
    attr_accessor :filters

    # @return [Array] a list of Node objects passed to the {#value} for use in a
    #         functional variable.  See {Context#define_functional_variable}.
    attr_accessor :parameters
    
    # creates a new {InjectNode} with the given value, filters and parameters
    # @param [VariableNode|OperationNode|BooleanInverseNode|ConstantNode] value see {#value}
    # @param [Array] filters see {#filters}
    # @param [Array] parameters see {#parameters}
    def initialize(value, filters=[], parameters=[])
      @value = value
      @filters = filters
      @parameters = parameters
    end

    # @param [InjectNode] rhs
    # @return [Boolean] true if the given InjectNode is equivalent by value to this node.
    def ==(rhs)
      self.value == rhs.value and
      self.filters == rhs.filters and
      self.parameters == rhs.parameters
    end

    # @return [Array] a list of variable names implied to be global by this node
    def implied_globals
      (@value.implied_globals + @filters.map(&:implied_globals).flatten).uniq
    end

    # @param [Context] context
    # @return [String] returns the evaluated {#value} of this node in the given 
    #         {Context} with any applicable {#parameters} after passed through 
    #         the given {#filters}.
    def evaluate(context)
      value = @value.eval(context)

      if value.is_a? Proc
        args = parameters.map {|p| p.eval(context) }
        value = value.call(context, *args)
      end

      @filters.each {|filter| value = filter.evaluate(context, value) }

      value
    end
  end
end