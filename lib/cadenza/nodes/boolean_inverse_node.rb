module Cadenza
   class BooleanInverseNode
      attr_accessor :expression

      def initialize(expression)
         @expression = expression
      end

      def ==(rhs)
         @expression == rhs.expression
      end

      def eval(context)
         !@expression.eval(context)
      end
   end
end