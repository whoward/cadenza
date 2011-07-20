module Cadenza
  class IfNode
   attr_accessor :expression, :true_children, :false_children

   def initialize(expression, true_children=[], false_children=[])
      @expression = expression
      @true_children = true_children
      @false_children = false_children
   end

   def implied_globals
      (@expression.implied_globals + true_children.map(&:implied_globals).flatten + false_children.map(&:implied_globals).flatten).uniq
   end

   def evaluate_expression_for_children(context)
      value = @expression.eval(context)

      if value == true
         return @true_children

      elsif value == false
         return @false_children

      elsif value.is_a?(String)
         return value.length == 0 || value =~ /\s+/ ? @false_children : @true_children

      elsif value.is_a?(Float) or value.is_a?(Fixnum)
         return value == 0 ? @false_children : @true_children

      else
         return !!value ? @true_children : @false_children
         
      end
   end

   def ==(rhs)
      @expression == rhs.expression and
      @true_children == rhs.true_children and
      @false_children == rhs.false_children
   end
  end
end