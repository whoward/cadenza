module Cadenza
   class RenderNode
      attr_accessor :filename
      
      def initialize(filename)
         @filename = filename
      end

      def implied_globals
         @filename.is_a?(VariableNode) ? @filename.implied_globals : []
      end
    
      def ==(rhs)
         @filename == rhs.filename
      end
   end
end