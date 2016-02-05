
module Cadenza
  # The {TextNode} is a very simple container for static text defined in your
  # template.
  class TextNode
    include TreeNode

    # @return [String] the content of the text in this node
    attr_accessor :text

    # Creates a new {TextNode} with the given text
    # @param [String] text see {#text}
    def initialize(text)
      @text = text
    end

    # @param [TextNode] rhs
    # @return [Boolean] true if the given {TextNode} is equivalent by value to
    #         this node.
    def ==(other)
      @text == other.text
    end
  end
end
