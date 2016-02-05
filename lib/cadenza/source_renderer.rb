
module Cadenza
  # SourceRenderer is a rendering implementation that turns a Cadenza AST back
  # into Cadenza source code.
  #
  # This is mainly intended for users who wish to migrate templates stored in
  # databases, or other storage devices, as their product progresses.
  #
  # For example: if in v1.0 of your app you define a filter X and deprecate it
  # in favour of filter Y you can use this renderer to automatically replace
  # instances of filter X with filter Y
  #
  # I'm sure there are many other exciting use cases for the imaginitive user,
  # feel free to let me know what else you do with it!
  #
  class SourceRenderer < BaseRenderer
    # This exception is raised when you try to transition to an undefined state
    IllegalStateError = Class.new(RuntimeError)

    # This exception is raised when you try to transition from one state to
    # another which is not allowed
    IllegalStateTransitionError = Class.new(RuntimeError)

    # A list of all valid states for the renderer
    ValidStates = [:text, :var, :tag].freeze

    # returns the current state of the renderer (see {#ValidStates})
    attr_reader :state

    # Renders the document given with the given context directly to a string
    # returns.
    # @param [DocumentNode] document_node the root of the AST you want to render.
    # @param [Context] context the context object to render the document with
    def self.render(document_node, context = {})
      io = StringIO.new
      new(io).render(document_node, context)
      io.string
    end

    # creates a new {SourceRenderer} and places it into the :text state
    def initialize(*args)
      @state = :text
      super
    end

    # transitions from the current state into the new state and emits opening
    # and closing tag markers appropriately during the transition.
    #
    # @raise [IllegalStateError] if you try to transition to an invalid state
    # @raise [IllegalStateTransitionError] if you try to transition from one
    #        one state to another which is not allowed
    def state=(new_state)
      # if trying to transition to a new state raise an exception
      fail IllegalStateError, new_state unless ValidStates.include?(new_state)

      # no special transition for the same state
      return if @state == new_state

      # handle any actions that occur on that state transition
      case @state
      when :text
        output << '{{ ' if new_state == :var
        output << '{% ' if new_state == :tag
      when :var
        output << ' }}' if new_state == :text
        fail IllegalStateTransitionError if new_state == :tag
      when :tag
        output << ' %}' if new_state == :text
        fail IllegalStateTransitionError if new_state == :var
      end

      # update to the new state
      @state = new_state
    end

    private

    def render_document(node, context, blocks)
      output << %({% extends "#{node.extends}" %}) if node.extends

      node.children.each { |child| render(child, context, blocks) }

      self.state = :text
    end

    def render_text(node, _context, _blocks)
      self.state = :text
      output << node.text
    end

    def render_constant(node, _context, _blocks)
      self.state = :var unless state == :tag
      output <<
        if node.value.is_a?(String)
          node.value.inspect
        else
          node.value
        end
    end

    def render_variable(node, context, blocks)
      self.state = :var unless state == :tag

      output << node.identifier

      node.parameters.each_with_index do |param_node, i|
        output << ' '
        render(param_node, context, blocks)
        output << ',' if i < node.parameters.length - 1
      end
    end

    def render_filtered_value(node, context, blocks)
      state == :var unless state == :tag

      render(node.value, context, blocks)

      node.filters.each do |filter|
        output << " | #{filter.identifier}"

        output << ': ' if filter.parameters.any?

        filter.parameters.each_with_index do |param, i|
          render(param, context, blocks)

          output << ', ' if i < filter.parameters.length - 1
        end
      end
    end

    def render_operation(node, context, blocks)
      self.state = :var unless state == :tag

      # calculate the operator precedence of the left, right and parent node
      node_precedence  = calculate_precedence(node)
      left_precedence  = calculate_precedence(node.left)
      right_precedence = calculate_precedence(node.right)

      need_left_brackets = left_precedence < node_precedence
      need_right_brackets = right_precedence <= node_precedence && !(node.right.is_a?(OperationNode) && node.right.operator == node.operator)

      # render the left node, wrapping in brackets if it is lower precedence
      output << '(' if need_left_brackets
      render(node.left, context, blocks)
      output << ')' if need_left_brackets

      # render the parent node's operator
      output << " #{node.operator} "

      # render the right node, wrapping it brackets if it is lower precedences
      output << '(' if need_right_brackets
      render(node.right, context, blocks)
      output << ')' if need_right_brackets
    end

    def render_if(node, context, blocks)
      self.state = :tag

      output << 'if '

      render(node.expression, context, blocks)

      self.state = :text

      node.true_children.each { |n| render(n, context, blocks) }

      output << '{% endif %}'
    end

    def render_for(node, context, blocks)
      self.state = :tag

      output << "for #{node.iterator.identifier} in "

      render(node.iterable, context, blocks)

      self.state = :text

      node.children.each { |n| render(n, context, blocks) }

      output << '{% endfor %}'
    end

    def render_block(node, context, blocks)
      self.state = :tag

      output << "block #{node.name}"

      self.state = :text

      node.children.each { |n| render(n, context, blocks) }

      output << '{% endblock %}'
    end

    def render_generic_block(node, context, blocks)
      self.state = :tag

      output << node.identifier

      output << ' ' if node.parameters.any?

      node.parameters.each_with_index do |param, i|
        render(param, context, blocks)

        output << ', ' if i < node.parameters.length - 1
      end

      self.state = :text

      node.children.each { |n| render(n, context, blocks) }

      output << '{% end %}'
    end

    def calculate_precedence(node)
      return 4 unless node.is_a?(OperationNode)

      case node.operator
      when '+', '-' then 2
      when '*', '/' then 3
      else 1
      end
    end
  end
end
