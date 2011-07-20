
module Cadenza
   class FilterNode
      attr_accessor :identifier, :parameters

      def initialize(identifier, parameters=[])
         @identifier = identifier
         @parameters = parameters
      end

      def ==(rhs)
         @identifier == rhs.identifier and
         @parameters == rhs.parameters
      end

      def implied_globals
         @parameters.map(&:implied_globals).flatten.uniq
      end

      def evaluate(context, value)
         params = [value] + @parameters.map {|x| x.eval(context) }
         context.evaluate_filter(@identifier, params)
      end
   end
end