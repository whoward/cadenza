 module Cadenza
   class GenericBlockNode
      attr_accessor :identifier, :children, :parameters

      def initialize(identifier, children, parameters=[])
         @identifier = identifier
         @children = children
         @parameters = parameters
      end    

      def implied_globals
         []
      end
    
      def ==(rhs)
         @identifier == rhs.identifier and
         @children == rhs.children and
         @parameters == rhs.parameters
      end
   end
 end