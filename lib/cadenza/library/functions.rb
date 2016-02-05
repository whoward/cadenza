
module Cadenza
  FunctionNotDefinedError = Class.new(Cadenza::Error)

  # Returns {FunctionNotDefinedError} when the deprecated {FunctionalVariableNotDefinedError} is requested
  # @private
  # @todo remove in v0.9.x
  def self.const_missing(const_name)
    super unless const_name == :FunctionalVariableNotDefinedError
    warn '`Cadenza::FunctionalVariableNotDefinedError` has been deprecated. ' \
         'Use `Cadenza::FunctionNotDefinedError` instead.'
    FunctionNotDefinedError
  end

  module Library
    module Functions
      # @!attribute [r] functions
      # @return [Hash] the function names mapped to their implementing procs
      # @deprecated Use {#functions} instead
      def functional_variables
        warn '`#functional_variables` has been deprecated.  Use `#functions` instead.'
        functions
      end

      # looks up the function by name
      #
      # @raise [FunctionNotDefinedError] if the function can not be found
      # @param [Symbol] name the name of the function to look up
      # @return [Proc] the function implementation
      # @deprecated Use {#lookup_function} instead
      def lookup_functional_variable(name)
        warn '`#lookup_functional_variable` has been deprecated.  Use `#lookup_function` instead.'
        lookup_function(name)
      end

      # defines a function proc with the given name
      #
      # @param [Symbol] name the name for the template to use for this variable
      # @yield [Context, *args] the block will receive the context object and a
      #                         variable number of arguments passed to the variable.
      # @return nil
      # @deprecated Use {#define_function} instead
      def define_functional_variable(name, &block)
        warn '`#define_functional_variable` has been deprecated.  Use `#define_function` instead.'
        define_function(name, &block)
      end

      # creates an alias of the given function name under a different name
      #
      # @raise [FunctionNotDefinedError] if the original function name isn't defined
      # @param [Symbol] original_name the original name of the function
      # @param [Symbol] alias_name the new name of the function
      # @return nil
      # @deprecated Use {#alias_function} instead
      def alias_functional_variable(original_name, alias_name)
        warn '`#alias_functional_variable` has been deprecated. Use `#alias_function` instead.'
        alias_function(original_name, alias_name)
      end

      # calls the defined function proc with the given parameters and returns
      # the result.
      #
      # @raise [FunctionNotDefinedError] if the named function doesn't exist
      # @param [Symbol] name the name of the function to evaluate
      # @param [Array] params a list of parameters to pass to the function
      #                block when calling it
      # @return [Object] the result of  evaluating the function
      # @deprecated Use {#evaluate_function} instead
      def evaluate_functional_variable(name, context, params = [])
        warn '`#evaluate_functional_variable` has been deprecated. Use `#evaluate_function` instead.'
        evaluate_function(name, context, params)
      end

      # @!attribute [r] functions
      # @return [Hash] the function names mapped to their implementing procs
      def functions
        @functions ||= {}
      end

      # looks up the function by name
      #
      # @raise [FunctionNotDefinedError] if the function can not be found
      # @param [Symbol] name the name of the function to look up
      # @return [Proc] the function implementation
      def lookup_function(name)
        functions.fetch(name.to_sym) { fail FunctionNotDefinedError, "undefined function '#{name}'" }
      end

      # defines a function proc with the given name
      #
      # @param [Symbol] name the name for the template to use for this variable
      # @yield [Context, *args] the block will receive the context object and a
      #                         variable number of arguments passed to the variable.
      # @return nil
      def define_function(name, &block)
        functions[name.to_sym] = block
        nil
      end

      # creates an alias of the given function name under a different name
      #
      # @raise [FunctionNotDefinedError] if the original function name isn't defined
      # @param [Symbol] original_name the original name of the function
      # @param [Symbol] alias_name the new name of the function
      # @return nil
      def alias_function(original_name, alias_name)
        define_function alias_name, &lookup_function(original_name)
      end

      # calls the defined function proc with the given parameters and returns
      # the result.
      #
      # @raise [FunctionNotDefinedError] if the named function doesn't exist
      # @param [Symbol] name the name of the function to evaluate
      # @param [Array] params a list of parameters to pass to the function
      #                block when calling it
      # @return [Object] the result of  evaluating the function
      def evaluate_function(name, context, params = [])
        lookup_function(name).call([context] + params)
      end
    end
  end
end
