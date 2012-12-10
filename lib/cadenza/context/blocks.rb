
module Cadenza
   BlockNotDefinedError = Class.new(Cadenza::Error)

   class Context
      module Blocks
         
         # @return [Hash] the block names mapped to their implementing procs
         def blocks
            @blocks ||= {}
         end

         def blocks=(rhs)
            @blocks = rhs
         end

         # defines a generic block proc with the given name
         #
         # @param [Symbol] name the name for the template to use for this block
         # @yield [Context, Array, *args] the block will receive the context object,
         #                                a list of Node objects (it's children), and
         #                                a variable number of aarguments passed to
         #                                the block.
         # @return nil
         def define_block(name, &block)
            blocks[name.to_sym] = block
            nil
         end

         def alias_block(original_name, alias_name)
            block = blocks[original_name.to_sym]
            raise BlockNotDefinedError.new("undefined block '#{original_name}'") if block.nil?
            blocks[alias_name.to_sym] = block
         end

         # calls the defined generic block proc with the given name and children
         # nodes.
         #
         # @raise [BlockNotDefinedError] if the named block does not exist
         # @param [Symbol] name the name of the block to evaluate
         # @param [Array] nodes the child nodes of the block
         # @param [Array, []] params a list of parameters to pass to the block
         #                    when calling it.
         # @return [String] the result of evaluating the block
         def evaluate_block(name, nodes, parameters)
            block = blocks[name.to_sym]
            raise BlockNotDefinedError.new("undefined block '#{name}") if block.nil?
            block.call(self, nodes, parameters)
         end
      end
   end
end