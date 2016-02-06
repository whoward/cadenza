require 'stringio'

module Cadenza
  # This renderer will output a string representing the AST in a tree format.  It is intended to be used
  # for debugging purposes.
  class SourceTreeRenderer < BaseRenderer
    # Renders the given AST root node as a source tree (helpful for debugging)
    # @todo move this to a module
    # @see Cadenza::TreeNode#to_tree
    # @param [DocumentNode] document_node the root of the AST you want to render.
    # @param [Context] context the context object to render the document with
    # @return [String] the rendered source tree
    def self.render(document_node, context = {})
      io = StringIO.new
      new(io).render(document_node, context)
      io.string
    end

    def initialize(*args)
      @level = 0
      super
    end

    private

    def render_document(node, context, blocks)
      output << 'Document'
      output << "(extends: #{node.extends})" if node.extends
      output << "\n"
      render_children(node.children, context, blocks)
    end

    def render_constant(node, _context, _blocks)
      output << "Constant(#{node.value.inspect})"
    end

    def render_text(node, _context, _blocks)
      output << "Text(#{node.text.inspect})"
    end

    def render_filter(node, context, blocks)
      output << 'Filter('
      output << node.identifier
      render_parameters(node.parameters, context, blocks)
      output << ')'
    end

    def render_variable(node, context, blocks)
      output << 'Variable('
      output << node.identifier
      render_parameters(node.parameters, context, blocks)
      output << ')'
    end

    def render_operation(node, context, blocks)
      output << "Operation(#{node.operator})\n"
      render_children([node.left, node.right], context, blocks)
    end

    def render_if(node, context, blocks)
      output << "If\n"

      output << "\u2503 Expression:\n"
      render_children([node.expression], context, blocks)
      output << "\n"

      if node.true_children.any?
        output << "\u2503 True Block:\n"
        render_children(node.true_children, context, blocks)
        output << "\n" if node.false_children.any?
      end

      return unless node.false_children.any?

      output << "\u2503 False Block:\n"

      render_children(node.false_children, context, blocks)
    end

    def render_for(node, context, blocks)
      output << "For(iterator: #{node.iterator.identifier}, iterable: #{node.iterable.identifier})\n"
      render_children(node.children, context, blocks)
    end

    def render_generic_block(node, context, blocks)
      output << 'GenericBlock('
      output << node.identifier
      render_parameters(node.parameters, context, blocks)
      output << ")\n"
      render_children(node.children, context, blocks)
    end

    def render_filtered_value(node, context, blocks)
      output << 'FilteredValue'
      render_parameters(node.filters, context, blocks)
      output << "\n"
      render_children([node.value], context, blocks)
    end

    def render_boolean_inverse(node, context, blocks)
      output << "BooleanInverse\n"
      render_children([node.expression], context, blocks)
    end

    def render_block(node, context, blocks)
      output << "Block(#{node.name})\n"
      render_children(node.children, context, blocks)
    end

    def render_parameters(parameters, context, blocks)
      if parameters.any?
        output << '['

        parameters.each_with_index do |param, idx|
          render(param, context, blocks)
          output << ', ' unless idx == parameters.length - 1
        end

        output << ']'
      end
    end

    def render_children(nodes, context, blocks)
      nodes.each_with_index do |node, idx|
        is_last_loop = idx == nodes.length - 1

        output << ("\u2503   " * @level)

        branch = is_last_loop ? "\u2516" : "\u2523"

        output << "#{branch}\u2501\u2501\u2501"

        @level += 1

        render(node, context, blocks)

        @level -= 1

        output << "\n" unless is_last_loop
      end
    end
  end
end
