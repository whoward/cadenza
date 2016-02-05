module Cadenza

   class RenderError < Cadenza::Error
      attr_reader :inner_error
      def initialize(err)
         super()
         @inner_error = err
      end
   end

   # BaseRenderer is a class you can use to more easily and cleanly implement 
   # your own rendering class.  To use this then subclass {BaseRenderer} and 
   # implement the appropriate render_xyz methods (see {#render} for details).
   class BaseRenderer
      # @return [IO] the io object that is being written to
      attr_reader :output

      # @return [Symbol|Proc] the error handler behavior. See {#initialize}
      attr_accessor :error_handler

      # creates a new renderer and assigns the given output io object to it
      # @param [IO] output_io the IO object which will be written to
      # @param [Hash] options the options to create the renderer with
      # @option options [Symbol|Proc] :error_handler (:suppress) the behavior
      #         the renderer should take when rendering a node results in an
      #         exception being raised.  The value may be any of:
      #
      #         - <b>:raise</b>
      #             re-raises the exception and passes it up (wrap it in a Cadenza::Error instance)
      #
      #         - <b>:dump</b>
      #              dumps the error's backtrace to the output, useful for debugging but inappropriate for production.
      #
      #         - <b>:suppress</b>
      #              returns immediately and provides no output (appropriate for production)
      #
      #         - <b>callable object</b> (ex. lambda, Proc or any other object that responds to #call)
      #              calls the object with the error instance passed as an argument and outputs the return value to the template
      def initialize(output_io, options={})
         @output = output_io
         @error_handler = options.fetch(:error_handler, :suppress)
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
         node_type = node.class.name.split("::").last

         node_name = underscore(node_type).gsub!(/_node$/, '')

         begin
            send("render_#{node_name}", node, context, blocks)
         rescue StandardError => e
            handle_exception(e)
         end
      end

      private
      
      # very stripped down form of ActiveSupport's underscore method
      def underscore(word)
         word.gsub!(/([a-z\d])([A-Z])/,'\1_\2').downcase!
      end
      
      def handle_exception(e)
         case error_handler
         
         when :suppress then nil # do nothing
         
         when :raise then fail Cadenza::RenderError, e
         
         when :dump 
            output << "<code>#{e.backtrace.join("\n")}</code>"
            
         when proc { |h| h.respond_to?(:call) }
            output << error_handler.call(e)
            
         else
            fail Cadenza::Error, "undefined error handler: #{error_handler.inspect}"
         
         end
      end
   end
end