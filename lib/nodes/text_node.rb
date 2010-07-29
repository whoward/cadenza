module Cadenza
  class TextNode < Cadenza::Node
    attr_accessor :text
    
    def initialize(text,pos)
      super(pos)
      self.text = text.value
    end
    
    def render(context={}, stream='')
      stream << self.text
    end
    
    def ==(rhs)
      super(rhs) and self.text == rhs.text
    end
    
    def to_s
      "TextNode(text: #{self.text})"
    end
  end
end