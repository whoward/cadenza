 module Cadenza
   # The {TextNode} is a very simple container for static text defined in your
   # template.
   class TextNode
      include TreeNode
      
      # @return [String] the content of the text in this node
      attr_accessor :text

      # Creates a new {TextNode} with the given text
      # @param [String] text see {#text}
      def initialize(text)
         @text = text
      end    

      # @return [Array] a list of global variable names implied by this node (none).
      def implied_globals
         []
      end
    
      # @param [TextNode] rhs
      # @return [Boolean] true if the given {TextNode} is equivalent by value to
      #         this node.
      def ==(rhs)
         @text == rhs.text
      end
   end
 end