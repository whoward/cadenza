
# frozen_string_literal: true

module Cadenza
  # This module contains the common methods to all nodes in the AST
  module TreeNode
    def to_tree
      SourceTreeRenderer.render(self)
    end
  end
end
