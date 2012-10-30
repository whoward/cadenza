module Cadenza  
   # The {VariableNode} holds a variable name (identifier) which it can render
   # the value of given a {Context} with the name defined in it's variable stack.
   class VariableNode
      # @return [String] the name given to this variable
      attr_accessor :identifier

      # @return [Array] a list of {FilterNode} to evaluate the value with, once the
      #                 value has itself been evaluated.
      attr_accessor :filters

      # @return [Array] a list of Node objects passed to the {#value} for use in a
      #         functional variable.  See {Context#define_functional_variable}.
      attr_accessor :parameters

      # creates a new {VariableNode} with the name given.
      # @param [String] identifier see {#identifier}
      # @param [Array] filters see {#filters}
      # @param [Array] parameters see {#parameters}
      def initialize(identifier, filters=[], parameters=[])
         @identifier = identifier
         @filters = filters
         @parameters = parameters
      end

      # @return [Array] a list of names which are implied to be global variables
      #                 from this node.
      def implied_globals
         #TODO: parameters
         ([self.identifier] + @filters.map(&:implied_globals).flatten + @parameters.map(&:implied_globals).flatten).uniq
      end

      # @param [Context] context
      # @return [Object] looks up and returns the value of this variable in the
      #                  given {Context}
      def eval(context)
         value = context.lookup(@identifier)

         if value.is_a? Proc
           args = parameters.map {|p| p.eval(context) }
           value = value.call(context, *args)
         end

         @filters.each {|filter| value = filter.evaluate(context, value) }

         value
      end
      
      # @param [VariableNode] rhs
      # @return [Boolean] if the given {VariableNode} is equivalent by value to
      #                   this node.
      def ==(rhs)
         self.identifier == rhs.identifier &&
         self.filters == rhs.filters &&
         self.parameters == rhs.parameters
      end
  end
end