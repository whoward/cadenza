module Cadenza
  class DocumentNode < Cadenza::Node
    attr_accessor :extends
    attr_accessor :children, :blocks
    
    def initialize(line=0,col=0)
      super(line,col)
      self.children = Array.new
      self.blocks = Hash.new
    end
    
    def render(context, stream)
      self.children.each { |child| child.render(context,stream) }
      return stream
    end
    
    def to_s
      value = "DocumentNode" << TAB
      self.children.each { |child| value << child.to_s.gsub(/\n/,TAB) << TAB }
      return value.rstrip
    end
  end
end