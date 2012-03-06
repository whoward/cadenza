module Cadenza
   # The {BooleanInverseNode} takes an expression and evaluates the logical inverse
   # of that expression so any expression that evaluates to true will return false
   # and vice versa.
   class BooleanInverseNode
      # @return [OperationNode] an evaluatable expression node
      attr_accessor :expression

      # creates a new {BooleanInverseNode} with the given expression
      # @param [OperationNode] the node this one will invert
      def initialize(expression)
         @expression = expression
      end

      # @param [BooleanInverseNode] rhs
      # @return [Boolean] if the given {BooleanInverseNode} is equivalent by value
      def ==(rhs)
         @expression == rhs.expression
      end

      # @param [Context] context
      # @return the value of this node evaluated with the data in the given {Context}
      def eval(context)
         #TODO: rename me to .evaluate
         !@expression.eval(context)
      end
   end
end