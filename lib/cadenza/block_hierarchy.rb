
module Cadenza
  # This class is used to help implement the "super" magic variable which is
  # available when rendering blocks using the {TextRenderer}.  It is essentially
  # a glorified hash table with some special rules for merging.
  #
  # Please treat this class as private to Cadenza, it is not meant to be used
  # outside of this gem.
  class BlockHierarchy
    # creates a new {BlockHierarchy} with the initial block hash
    # @param [Hash] data the initial data to merge into the names hash
    def initialize(data = nil)
      @names = {}

      merge(data) if data
    end

    # fetches the inheritance chain for the given block name.  if the block
    # name is undefined then an empty array is returned.
    # @return [Array] the inheritance chain
    def fetch(block_name)
      @names[block_name.to_s] || []
    end

    alias [] fetch

    # appends the given block to the inheritance chain of it's name
    # @param [BlockNode] block
    def push(block)
      @names[block.name.to_s] ||= []
      @names[block.name.to_s] << block
    end

    alias << push

    # merges the given hash of blocks (name -> block) onto the end of each
    # inheritance chain
    # @param [Hash] hash
    def merge(hash)
      hash.each { |_k, v| self << v }
    end
  end
end
