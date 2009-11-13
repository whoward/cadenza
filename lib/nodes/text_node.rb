module Cadenza
  class TextNode < Cadenza::Node
    attr_accessor :text
    
    def initialize(text,line,col)
      super(line,col)
      self.text = text
    end
    
    def render(context,stream)
      stream << self.text
    end
    
    def to_s
      "TextNode(text: #{self.text})"
    end
  end
end