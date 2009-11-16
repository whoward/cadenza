module Cadenza
  class DocumentNode < Cadenza::Node
    attr_accessor :extends
    attr_accessor :children, :blocks
    
    def initialize(line=0,col=0)
      super(Struct.new(:line,:column).new(1,1))
      self.children = Array.new
      self.blocks = Hash.new
    end
    
    def render(context, stream, overriding_blocks=Hash.new)
      
      overriding_blocks.each do | name, block |
        local = self.blocks.fetch(name) rescue next
        local.overridden_by = block
        block.overrides = local
      end
      
      if self.extends.nil?
        # There is no base document, render the document as normal
        self.children.each { |child| child.render(context,stream) }
        return stream
      else
        extends_template = Loader.get_template('Filesystem', self.extends.eval(context))
        return extends_template.render(context, stream, self.blocks)
      end
    end
    
    def to_s
      value = "DocumentNode" << TAB
      self.children.each { |child| value << child.to_s.gsub(/\n/,TAB) << TAB }
      return value.rstrip
    end
  end
end