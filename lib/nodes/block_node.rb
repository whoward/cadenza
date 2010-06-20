module Cadenza
  class BlockNodeProxy < Struct.new(:context, :stream, :overrides)
    def super
      return overrides.render(context,stream,true) unless overrides.nil?
    end
  end
  
  class BlockNode < Cadenza::Node
    attr_accessor :name, :children
    attr_accessor :overrides, :overridden_by
    
    def initialize(name,pos)
      super(pos)
      self.name = name.value
      self.children = Array.new
    end
    
    def render(context,stream,is_super_call=false)
      unless is_super_call or self.overridden_by.nil?
        return self.overridden_by.render(context,stream)
      end
      
      inner_context = context.clone
      inner_context.store('block', BlockNodeProxy.new(context, stream, overrides))
      
      self.children.each { |child| child.render(inner_context,stream) }
    end
    
    # overrides and overriden_by are not attributes of the "node" but the document hierarchy, so
    # they wont be counted for equality of two BlockNodes
    def ==(rhs)
      super(rhs) and
      self.name == rhs.name and
      self.children == rhs.children
    end
    
    def to_s
      value = "BlockNode(name: #{self.name})" << TAB
      self.children.each { |child| value << child.to_s.gsub(/\n/,TAB) << TAB }
      return value.rstrip
    end
    
  end
end