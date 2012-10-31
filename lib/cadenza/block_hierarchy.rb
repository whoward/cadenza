
module Cadenza
   class BlockHierarchy

      def initialize(data=nil)
         @names = Hash.new

         merge(data) if data
      end

      def fetch(block_name)
         @names[block_name.to_s] || []
      end

      alias :[] :fetch

      def push(block)
         @names[block.name.to_s] ||= []
         @names[block.name.to_s] << block
      end

      alias :<< :push

      def merge(hash)
         hash.each {|k,v| self << v }
      end
   end
end