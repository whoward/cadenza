module Cadenza
   # BaseRenderer is a class you can use to more easily and cleanly implement 
   # your own rendering class.  To use this then subclass {BaseRenderer} and 
   # implement the appropriate render_xyz methods (see {#render} for details).
   class BaseRenderer
      # @return [IO] the io object that is being written to
      attr_reader :output

      # @deprecated temporary hack, will be removed later
      # @return [DocumentNode] the node which is at the root of the AST
      attr_reader :document

      # creates a new renderer and assigns the given output io object to it
      # @param [IO] output_io the IO object which will be written to
      def initialize(output_io)
         @output = output_io
      end
      
      # renders the given document node to the output stream given in the 
      # constructor.  this method will call the render_xyz method for the node
      # given, where xyz is the demodulized underscored version of the node's 
      # class name.  for example: given a Cadenza::DocumentNode this method will
      # call render_document_node
      #
      # @param [Node] node the node to render
      # @param [Context] context the context to render with
      # @param [Hash] blocks a mapping of the block names to the matching 
      #               {BlockNode}.  The blocks given should be rendered instead
      #               of blocks of the same name in the given document.
      def render(node, context, blocks={})
         #TODO: memoizing this is a terrible smell, add a "parent" hierarchy so
         # we can always find the root node from any node in the AST
         @document ||= node

         node_type = node.class.name.split("::").last

         node_name = underscore(node_type).gsub!(/_node$/, '')

         send("render_#{node_name}", node, context, blocks)
      end

   private

      # very stripped down form of ActiveSupport's underscore method
      def underscore(word)
         word.gsub!(/([a-z\d])([A-Z])/,'\1_\2').downcase!
      end
   end
end