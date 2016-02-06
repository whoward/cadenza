
module Cadenza
  # This exception is raised when a function is referred to but is not defined
  FunctionNotDefinedError = Class.new(Cadenza::Error)

  module Library
    # The logic for storing and calling functions is found in this module
    module Functions
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
        functions.fetch(name.to_sym) { raise FunctionNotDefinedError, "undefined function '#{name}'" }
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
