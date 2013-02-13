
module Cadenza
   BlockNotDefinedError = Class.new(Cadenza::Error)

   module Library
      module Blocks
         
         # @!attribute [r] blocks
         # @return [Hash] the block names mapped to their implementing procs
         def blocks
            @blocks ||= {}
         end

         # looks up the block by name
         # 
         # @raise [BlockNotDefinedError] if the block can not be found
         # @param [Symbol] name the name of the block to look up
         # @return [Proc] the block implementation
         def lookup_block(name)
            blocks.fetch(name.to_sym) { raise BlockNotDefinedError.new("undefined block '#{name}'") }
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

         # creates an alias of the given block name under a different name 
         #
         # @raise [BlockNotDefinedError] if the original block name isn't defined
         # @param [Symbol] original_name the original name of the block
         # @param [Symbol] alias_name the new name of the block
         # @return nil
         def alias_block(original_name, alias_name)
            define_block alias_name, &lookup_block(original_name)
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
         def evaluate_block(name, context, nodes, parameters)
            lookup_block(name).call(context, nodes, parameters)
         end
      end
   end
end