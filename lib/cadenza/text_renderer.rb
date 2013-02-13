require 'cadenza/block_hierarchy'
require 'stringio'

module Cadenza
   # The {TextRenderer} is the standard rendering logic for Cadenza.  It will 
   # render an AST according to the rules specified in the Cadenza manual.  See
   # the manual for details.
   class TextRenderer < BaseRenderer

      # Renders the document given with the given context directly to a string 
      # returns.
      # @param [DocumentNode] document_node the root of the AST you want to render.
      # @param [Context] context the context object to render the document with
      def self.render(document_node, context)
         io = StringIO.new
         new(io).render(document_node, context)
         io.string
      end

      def render(node, context, blocks={})
         passed_blocks = blocks.is_a?(BlockHierarchy) ? blocks : BlockHierarchy.new(blocks)

         super(node, context, passed_blocks)
      end

   private
   
      def render_document(node, context, blocks)
         # merge the document's blocks into the inherited blocks
         blocks.merge(node.blocks)

         if node.extends
            # load the template of the document and render it to the same output stream
            template = context.load_template!(node.extends)

            render(template, context, blocks)
         else
            node.children.each {|x| render(x, context, blocks) }
         end         
      end

      def render_block(node, context, blocks)
         # create the full inheritance chain with this node on top, making sure
         # not to mutate the block hierarchy's internals
         chain = blocks[node.name].dup << node
         
         super_fn = lambda do |params|
            parent_node = chain.shift

            parent_node.children.each {|x| render(x, context, blocks) } if parent_node

            nil
         end

         context.push('super' => super_fn)

         chain.shift.children.each {|x| render(x, context, blocks) }

         context.pop
      end

      def render_text(node, context, blocks)
         output << node.text
      end

      def render_if(node, context, blocks)
         node.evaluate_expression_for_children(context).each {|x| render(x, context, blocks) }
      end

      def render_for(node, context, blocks)
         # sadly to_enum doesn't work in 1.8.x so we need to array-ify the iterable first
         values = node.iterable.eval(context).to_a
         iterator = node.iterator.identifier

         values.each_with_index do |value, counter|
            is_first = (counter == 0) ? true : false
            is_last  = (counter == values.length - 1) ? true : false

            # push the inner context with the 'magic' variables
            context.push({
               iterator => value,
               'forloop' => {
                  'counter' => counter + 1,
                  'counter0' => counter,
                  'first' => is_first,
                  'last' => is_last
               }
            })

            # render each of the child nodes with the context
            node.children.each {|x| render(x, context, blocks) }

            # pop the inner context off
            context.pop

            # increment the counter
            counter += 1
         end
      end

      def render_generic_block(node, context, blocks)
         output << context.evaluate_block(node.identifier, node.children, node.parameters)
      end

      def render_constant(node, context, blocks)
         output << node.eval(context).to_s
      end

      alias :render_variable        :render_constant
      alias :render_operation       :render_constant
      alias :render_boolean_inverse :render_constant
      alias :render_filtered_value  :render_constant

   end
end