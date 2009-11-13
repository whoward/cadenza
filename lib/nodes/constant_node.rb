module Cadenza
  class ConstantNode < Cadenza::Node
     attr_accessor :value
     
     def initialize(value,line,col)
       super(line,col)
       self.value = value
     end
          
     def render(context, stream)
       stream << self.value.to_s
     end

     def eval(context)
       self.value
     end
     
    def to_s
      "ConstantNode(value:#{self.value})"
    end
     
  end
end