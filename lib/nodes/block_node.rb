module Cadenza
  class BlockNode < Cadenza::Node
    attr_accessor :name, :children
    attr_accessor :overrides, :overriden_by
    
    def initialize(name,line,col)
      super(line,col)
      self.name = name
      self.children = Array.new
    end
    
    def render(context,stream)
      self.children.each { |child| child.render(context,stream) }
    end
    
    def to_s
      value = "BlockNode(name: #{self.name})" << TAB
      self.children.each { |child| value << child.to_s.gsub(/\n/,TAB) << TAB }
      return value.rstrip
    end
    
  end
end