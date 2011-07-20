module Cadenza
  class DocumentNode
    attr_accessor :extends
    attr_accessor :children
    attr_accessor :blocks
    
    def initialize(children=[])
      @children = children
      @blocks = {}
    end

    def ==(rhs)
      @children == rhs.children and
      @extends == rhs.extends and
      @blocks == rhs.blocks
    end

    def add_block(block)
      @blocks[block.name] = block
    end

    def implied_globals
      @children.map(&:implied_globals).flatten.uniq
    end

  end
end