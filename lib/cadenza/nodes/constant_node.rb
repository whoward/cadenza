module Cadenza
   class ConstantNode
      attr_accessor :value

      def initialize(value)
         @value = value
      end
    
      def implied_globals
         []
      end

      def eval(context)
         @value
      end
          
      def ==(rhs)
         @value == rhs.value
      end
   end
end