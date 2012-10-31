
module Cadenza

   class FilteredValueNode
      # @return [Node] the value to be filtered
      attr_accessor :value

      # @return [Array] a list of {FilterNode} to evaluate the value with, once the
      #                 value has itself been evaluated.
      attr_accessor :filters

      # creates a new {FilteredValueNode}.
      # @param [String] identifier see {#identifier}
      # @param [Array] filters see {#filters}
      def initialize(value, filters=[])
         @value = value
         @filters = filters
      end
      
      # @return [Array] a list of names which are implied to be global variables
      #                 from this node.
      def implied_globals
         (@value.implied_globals + @filters.map(&:implied_globals).flatten).uniq
      end

      # @param [Context] context
      # @return [Object] gets the value and returns it after being passed 
      #                  through all filters
      def eval(context)
         value = @value.eval(context)

         @filters.each {|filter| value = filter.evaluate(context, value) }

         value
      end

      # @param [FilteredValueNode] rhs
      # @return [Boolean] if the given {FilteredValueNode} is equivalent by 
      #                   value to this node.
      def ==(rhs)
         self.value == rhs.value && self.filters == rhs.filters
      end


   end

end