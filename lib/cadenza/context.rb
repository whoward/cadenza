
module Cadenza
   # The {Context} class is an essential class in Cadenza that contains all the
   # data necessary to render a template to it's output.  The context holds all
   # defined variable names (see {#stack}), filters (see {#filters}), 
   # functional variables (see {#functional_variables}), generic blocks 
   # (see {#blocks}), loaders (see {#loaders}) and configuration data as well 
   # as all the methods you should need to define and evaluate those.
   class Context
      include Cadenza::Context::Stack
      include Cadenza::Context::Filters
      include Cadenza::Context::Blocks
      include Cadenza::Context::FunctionalVariables
      include Cadenza::Context::Loaders

      # looks up the given identifier name on the given ruby object using
      # Cadenza's internal logic for doing so.
      #
      # {Array} objects allow identifiers in the form of numbers to retrieve
      # the index specified.  Example: alphabet.0 returns "a"
      #
      # {Hash} objects allow identifiers to be fetched as keys of that hash.
      #
      # Any object which is a subclass of {ContextObject} will have a value 
      # looked up according to the logic defined in {ContextObject#invoke_context_method}
      #
      # @param [Symbol|String] identifier the name of the value to look up on this object
      # @param [Object] object the object to look up the value on
      # @return [Object] the result of the lookup
      def self.lookup_on_object(identifier, object)
         sym_identifier = identifier.to_sym

         # allow looking up array indexes with dot notation, example: alphabet.0 => "a"
         #TODO: the /\d+/ regex doesn't have the \A\z terminators, could that allow expected calling? example: alpabet.a0
         if object.respond_to?(:[]) && object.is_a?(Array) && identifier =~ /\d+/
            return object[identifier.to_i]
         end

         # otherwise if it's a hash look up the string or symbolized key
         if object.respond_to?(:[]) && object.is_a?(Hash) && (object.has_key?(identifier) || object.has_key?(sym_identifier))
            return object[identifier] || object[sym_identifier]
         end

         # if the identifier is a callable method then call that
         return object.send(:invoke_context_method, identifier) if object.is_a?(Cadenza::ContextObject)
         
         nil
      end

      # creates a new context object with an empty stack, filter list, functional
      # variable list, block list, loaders list and default configuration options.
      #
      # When created you can push an optional scope onto as the initial stack
      #
      # @param [Hash] initial_scope the initial scope for the context
      def initialize(initial_scope={})
         push initial_scope
      end

      # creates a new instance of the context with the stack, loaders, filters,
      # functional variables and blocks shallow copied.
      #
      # @return [Context] the cloned context
      def clone
         copy = super
         copy.instance_variable_set("@stack", stack.dup)
         copy.instance_variable_set("@loaders", loaders.dup)
         copy.instance_variable_set("@filters", filters.dup)
         copy.instance_variable_set("@functional_variables", functional_variables.dup)
         copy.instance_variable_set("@blocks", blocks.dup)
         
         copy
      end

   end

end
