module Cadenza
   # The {OperationNode} is a node which contains an evaluatable {#left} and 
   # {#right} subtree and an {#operator} with which to evaluate it.
  class OperationNode
      include TreeNode

      # @return [VariableNode|ConstantNode|OperationNode|BooleanInverseNode] the
      #         root of the left subtree to evaluate for this operation.
      attr_accessor :left

      # @return [VariableNode|ConstantNode|OperationNode|BooleanInverseNode] the
      #         root of the right subtree to evaluate for this operation.
      attr_accessor :right

      # The operation of this node to do when evaluating.  The operator should be
      # one of the following values:
      # - "==" for equal
      # - "!=" for not equal
      # - ">=" for greater than or equal to
      # - "<=" for less than or equal to
      # - ">" for greater than
      # - "<" for less than
      # - "and" for the boolean 'and' conjunction
      # - "or" for the boolean 'or' conjunction
      # - "+" for the arithmetic addition operation
      # - "-" for the arithmetic subtraction operation
      # - "*" for the arithmetic multiplication operation
      # - "/" for the arithmetic division operation
      # @return [String] the operation for this node
      attr_accessor :operator

      # creates a new {OperationNode} with the given left and right subtrees and 
      # the given operator.
      # @param [VariableNode|ConstantNode|OperationNode|BooleanInverseNode] left see {#left}
      # @param [VariableNode|ConstantNode|OperationNode|BooleanInverseNode] right see {#right} 
      # @param [String] operator see {#operator}
      def initialize(left, operator, right)
         @left = left
         @right = right
         @operator = operator
      end
          
      # @return [Array] a list of variable names implied to be global in this node
      def implied_globals
         @left.implied_globals | @right.implied_globals
      end
    
      # Evalutes the left and right subtree in the given context and uses the
      # {#operator} to manipulate the two values into a single output value
      # which is then returned.
      # @param [Context] context
      # @return [Object] the result of performing the operation on the evaluated
      #         left and right subtrees in the given context.
      def eval(context)
         l = @left.eval(context)
         r = @right.eval(context)

         case @operator
            when '=='
               return l == r

            when '!='
               return l != r

            when '>='
               return l >= r

            when '<='
               return l <= r

            when '>'
               return l > r

            when '<'
               return l < r

            when 'and'
               return l && r

            when 'or'
               return l || r

            when '+'
               return l + r

            when '-'
               return l - r

            when '*'
               return l * r

            when '/'
               return l / r

            else throw "undefined operator: #{@operator}"
         end
      end

      # @param [OperationNode] rhs
      # @return [Boolean] true if the given {OperationNode} is equivalent by value
      #         to this node.
      def ==(rhs)
         @operator == rhs.operator &&
         @left == rhs.left &&
         @right == rhs.right
      end
  end
end