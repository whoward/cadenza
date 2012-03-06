module Cadenza  
   # The {VariableNode} holds a variable name (identifier) which it can render
   # the value of given a {Context} with the name defined in it's variable stack.
   class VariableNode
      # @return [String] the name given to this variable
      attr_accessor :identifier

      # creates a new {VariableNode} with the name given.
      # @param [String] identifier see {#identifier}
      def initialize(identifier)
         @identifier = identifier
      end

      # @return [Array] a list of names which are implied to be global variables
      #                 from this node.
      def implied_globals
         [self.identifier]
      end

      # @param [Context] context
      # @return [Object] looks up and returns the value of this variable in the
      #                  given {Context}
      def eval(context)
         context.lookup(@identifier)
      end
      
      # @param [VariableNode] rhs
      # @return [Boolean] if the given {VariableNode} is equivalent by value to
      #                   this node.
      def ==(rhs)
         self.identifier == rhs.identifier
      end
  end
end