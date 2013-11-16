module Cadenza
   # The {IfNode} is a structure for rendering one of it's two given blocks 
   # based on the evaluation of an expression in the current {Context}.
   class IfNode
      include TreeNode
      
      # @return [OperationNode|BooleanInverseNode] the evaluatable expression 
      #         used to determine which set of nodes to render.
      attr_accessor :expression

      # @return [Array] A list of nodes which will be rendered if the {#expression}
      #                 evaluates to true in the given {Context}.
      attr_accessor :true_children

      # @return [Array] A list of nodes which will be rendered if the {#expression}
      #                 evaluates to false in the given {Context}.
      attr_accessor :false_children

      # creates a new {IfNode} with the given evaluatable expression and pair of
      # blocks.
      # @param [OperationNode|BooleanInverseNode] expression the expression to evaluate
      # @param [Array] true_children a list of Node objects which will be rendered
      #        if the {#expression} evaluates to true in the given {Context}.
      # @param [Array] false_children a list of Node objects which will be
      #        rendered if the {#expression} evaluates to false in the given {Context}.
      def initialize(expression, true_children=[], false_children=[])
         @expression = expression
         @true_children = true_children
         @false_children = false_children
      end

      # @return [Array] a list of variable names implied to be global for this node.
      def implied_globals
         (@expression.implied_globals + true_children.map(&:implied_globals).flatten + false_children.map(&:implied_globals).flatten).uniq
      end

      # @param [Context] context
      # @return [Array] evalutes the expression in the given context and returns
      #         a list of nodes which should be rendered based on the result of
      #         that evaluation.
      def evaluate_expression_for_children(context)
         value = @expression.eval(context)

         if value == true
            return @true_children

         elsif value == false
            return @false_children

         elsif value.is_a?(String)
            return value.length == 0 || value =~ /\s+/ ? @false_children : @true_children

         elsif value.is_a?(Float) or value.is_a?(Fixnum)
            return value == 0 ? @false_children : @true_children

         else
            return !!value ? @true_children : @false_children
            
         end
      end

      # @param [IfNode] rhs
      # @return [Boolean] true if the given node is equivalent by value to this node.
      def ==(rhs)
         @expression == rhs.expression &&
         @true_children == rhs.true_children &&
         @false_children == rhs.false_children
      end
   end
end