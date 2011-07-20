module Cadenza
  
   class BlockNode
      attr_accessor :name, :children

      def initialize(name, children)
         @name = name
         @children = children
      end

      def implied_globals
         @children.map(&:implied_globals).flatten.uniq
      end

      def ==(rhs)
         @name == rhs.name and
         @children == rhs.children
      end
  end
end