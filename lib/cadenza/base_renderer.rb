module Cadenza
   class BaseRenderer
      attr_reader :output, :document

      def initialize(output_io)
         @output = output_io
      end
      
      def render(node, context, blocks={})
         @document ||= node

         node_type = node.class.name.split("::").last

         node_name = underscore(node_type).gsub!(/_node$/, '')

         send("render_#{node_name}", node, context, blocks)
      end

      # very stripped down form of ActiveSupport's underscore method
      def underscore(word)
         word.gsub!(/([a-z\d])([A-Z])/,'\1_\2').downcase!
      end
   end
end