module Cadenza  
   class VariableNode
      attr_accessor :identifier

      def initialize(identifier)
         @identifier = identifier
      end

      def implied_globals
         [self.identifier]
      end

      def eval(context)
         context.lookup(@identifier)
      end
      
      def ==(rhs)
         self.identifier == rhs.identifier
      end
  end
end