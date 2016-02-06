require 'cadenza/library/filters'
require 'cadenza/library/blocks'
require 'cadenza/library/functions'
require 'cadenza/library/expectation'

module Cadenza
  # Libraries provide a way to define a set of filters, blocks and functions which can be easily included into a context
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
        base.define_singleton_method(:inherited) do |subclass|
          subclass.filters.merge!(filters)
          subclass.blocks.merge!(blocks)
          subclass.functions.merge!(functions)
        end
      else
        base.define_singleton_method(:enhance) do |&block|
          Cadenza::Library.send(:__build, self, &block)
        end

        base.define_singleton_method(:included) do |library|
          library.filters.merge!(filters)
          library.blocks.merge!(blocks)
          library.functions.merge!(functions)
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
