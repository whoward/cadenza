module Cadenza
  class ConstantNode < Cadenza::Node
    attr_accessor :value
     
    def initialize(value,pos)
      super(pos)
      self.value = value.value
    end
          
    def render(context, stream)
      stream << self.value.to_s
    end
    
    def eval(context)
      self.value
    end
    
    def ==(rhs)
      super(rhs) and self.value == rhs.value
    end
     
    def to_s
      "ConstantNode(value:#{self.value})"
    end
     
  end
end