module Cadenza
  class IfNode < Cadenza::Node
    attr_accessor :expression, :true_children, :false_children
    
    def initialize(expression,true_children,false_children,line,col)
      super(line,col)
      self.expression = expression
      self.true_children  = true_children
      self.false_children = false_children
    end
    
    def render(context,stream)
      evaluation = value_of(self.expression,context)
      
      if evaluation
        self.true_children.each  {|child| child.render(context,stream)}
      elsif self.false_children
        self.false_children.each {|child| child.render(context, stream)}
      else
        return ''        
      end      
      
      return stream
    end
    
    def to_s
      value = "IfNode" << TAB
      
      # Print out the expression of this node 
      value << "<CONDITION>" << TAB
      value << self.expression.to_s.gsub(/\n/,TAB) << TAB
      
      # Depending on whether or not there is an else block print <IF TRUE> or <THEN> 
      value << "<IF TRUE>" << TAB unless self.false_children.nil?
      value << "<THEN>" << TAB if self.false_children.nil?
      
      # there will always be a true block, so print it
      value << self.true_children.to_s.gsub(/\n/,TAB) << TAB
      
      # if there was no else block provided then don't print it
      unless self.false_children.nil?
        value << "<IF FALSE>" << TAB
        value << self.false_children.to_s.gsub(/\n/,TAB) << TAB
      end
      
      return value
    end
  end
end