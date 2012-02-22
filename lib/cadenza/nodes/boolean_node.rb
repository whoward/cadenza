module Cadenza
  class BooleanNode
      attr_accessor :left, :right, :operator

      def initialize(left, operator, right)
         @left = left
         @right = right
         @operator = operator
      end
          
      def implied_globals
         @left.implied_globals | @right.implied_globals
      end
    
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

            else throw "undefined operator: #{@operator}"
         end
      end

      def ==(rhs)
         @operator == rhs.operator and
         @left == rhs.left and
         @right == rhs.right
      end
  end
end