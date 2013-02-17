
module Cadenza
   module TreeNode

      def to_tree
         SourceTreeRenderer.render(self)
      end
   end
end