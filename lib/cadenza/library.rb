require 'cadenza/library/filters'
require 'cadenza/library/blocks'
require 'cadenza/library/functional_variables'

module Cadenza
   module Library
      def self.build(&block)
         __build(nil, &block)
      end

      def self.extended(base)
         base.extend Cadenza::Library::Filters
         base.extend Cadenza::Library::Blocks
         base.extend Cadenza::Library::FunctionalVariables

         if base.is_a?(Class)
            def base.inherited(base)
               base.filters.merge!(self.filters)
               base.blocks.merge!(self.blocks)
               base.functional_variables.merge!(self.functional_variables)
            end
         else
            def base.enhance(&block)
               Cadenza::Library.send(:__build, self, &block)
            end

            def base.included(library)
               library.filters.merge!(self.filters)
               library.blocks.merge!(self.blocks)
               library.functional_variables.merge!(self.functional_variables)
            end
         end
      end

   private

      def self.__build(super_module, &block)
         mod = Module.new
         mod.extend(self)
         mod.send(:include, super_module) if super_module
         mod.instance_eval(&block) if block
         mod
      end

   end
end