module Cadenza
   class GenericStatementNode
      attr_accessor :name, :parameters

      def initialize(name, parameters=[])
         @name = name
         @parameters = parameters
      end
    
      def implied_globals
         parameters.map(&:implied_globals).flatten.uniq
      end
    
      def ==(rhs)
         @name == rhs.name and
         @parameters == rhs.parameters
      end
   end
end