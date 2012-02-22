module Cadenza
  #TODO: merge into BooleanNode and rename to OperationNode
  class ArithmeticNode
    attr_accessor :left, :right, :operator

    def initialize(left, op, right)
      @left = left
      @right = right
      @operator = op
    end

    def ==(rhs)
      @operator == rhs.operator and
      @left == rhs.left and
      @right == rhs.right
    end

    def implied_globals
      @left.implied_globals | @right.implied_globals
    end
    
    def eval(context)
      l = self.left.eval(context)
      r = self.right.eval(context)
      
      case self.operator
        when '+'
          return l + r
          
        when '-'
          return l - r
          
        when '*'
          return l * r
          
        when '/'
          # raise TemplateError('division by zero',self) if r == 0
          return l / r
      end
    end
  end
end