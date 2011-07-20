
module Cadenza
   class TextRenderer < BaseRenderer
      def render_document(node, context, blocks)
         if node.extends
            # merge the inherited blocks onto this document's blocks to
            # determine what to pass to the layout template
            blocks = node.blocks.merge(blocks)

            # load the template of the document and render it to the same output stream
            template = context.load_template!(node.extends)

            document = template

            render(template, context, blocks)
         else
            node.children.each {|x| render(x, context, blocks) }
         end         
      end

      def render_render(node, context, blocks)
         template = context.load_template(node.filename) || ""

         TextRenderer.new(output).render(template, context)
      end

      def render_block(node, context, blocks)
         (blocks[node.name] || node).children.each {|x| render(x, context) }
      end

      def render_text(node, context, blocks)
         output << node.text
      end

      def render_inject(node, context, blocks)
         output << node.evaluate(context).to_s
      end

      def render_if(node, context, blocks)
         node.evaluate_expression_for_children(context).each {|x| render(x, context) }
      end

      def render_generic_statement(node, context, blocks)
         params = node.parameters.map {|n| n.eval(context) }
         
         context.evaluate_statement(node.name, params)
      end

      def render_for(node, context, blocks)
         enumerator = node.iterable.eval(context).to_enum
         iterator = node.iterator.identifier

         counter = 0
         loop do
            # grab some values for the inner context
            value = enumerator.next rescue break

            is_first = (counter == 0)
            is_last  = enumerator.peek rescue false ? true : false  #TODO: this doesn't work in 1.8.x

            # push the inner context with the 'magic' variables
            context.push({
               iterator => value, 
               'counter' => counter + 1, 
               'counter0' => counter, 
               'first' => is_first, 
               'last' => is_last
            })

            # render each of the child nodes with the context
            node.children.each {|x| render(x, context) }

            # pop the inner context off
            context.pop

            # increment the counter
            counter += 1
         end
      end

      # none of these should appear directly inside the body of the 
      # document but for safety we will render them anyways
      def render_constant(node, context, blocks)
         output << node.eval(context).to_s
      end

      alias :render_variable   :render_constant
      alias :render_arithmetic :render_constant
      alias :render_boolean    :render_constant

   end
end