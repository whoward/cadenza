require 'cadenza/library/filters'
require 'cadenza/library/blocks'
require 'cadenza/library/functions'
require 'cadenza/library/expectation'

module Cadenza
   module Library

      # Instantiates a new library module and calls the passed block in the
      # context of the new module.  This makes the block build the library in the
      # form of a DSL.
      #
      # The new module will always extend the following modules:
      # - {Cadenza::Library::Filters}
      # - {Cadenza::Library::Blocks}
      # - {Cadenza::Library::Functions}
      def self.build(&block)
         __build(nil, &block)
      end

      # @private
      def self.extended(base)
         base.extend Cadenza::Library::Filters
         base.extend Cadenza::Library::Blocks
         base.extend Cadenza::Library::Functions

         if base.is_a?(Class)
            def base.inherited(base)
               base.filters.merge!(self.filters)
               base.blocks.merge!(self.blocks)
               base.functions.merge!(self.functions)
            end
         else
            def base.enhance(&block)
               Cadenza::Library.send(:__build, self, &block)
            end

            def base.included(library)
               library.filters.merge!(self.filters)
               library.blocks.merge!(self.blocks)
               library.functions.merge!(self.functions)
            end
         end
      end

      protected
   
      def expect(params)
         Expectation.new(params)
      end

      def self.__build(super_module, &block)
         mod = Module.new
         mod.extend(self)
         mod.send(:include, super_module) if super_module
         mod.instance_eval(&block) if block
         mod
      end
      private_class_method :__build

   end
end