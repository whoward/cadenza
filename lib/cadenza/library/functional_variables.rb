
module Cadenza
   FunctionalVariableNotDefinedError = Class.new(Cadenza::Error)

   module Library
      module FunctionalVariables

         # @!attribute [r] functional_variables
         # @return [Hash] the functional variable names mapped to their implementing procs
         def functional_variables
            @functional_variables ||= {}
         end

         # looks up the functional variable by name
         # 
         # @raise [FunctionalVariableNotDefinedError] if the functional variable can not be found
         # @param [Symbol] name the name of the functional variable to look up
         # @return [Proc] the functional variable implementation
         def lookup_functional_variable(name)
            functional_variables.fetch(name.to_sym) { raise FunctionalVariableNotDefinedError.new("undefined functional variable '#{name}'") }
         end

         # defines a functional variable proc with the given name
         #
         # @param [Symbol] name the name for the template to use for this variable
         # @yield [Context, *args] the block will receive the context object and a
         #                         variable number of arguments passed to the variable.
         # @return nil
         def define_functional_variable(name, &block)
            functional_variables[name.to_sym] = block
            nil
         end
         
         # creates an alias of the given functional variable name under a different name 
         #
         # @raise [FunctionalVariableNotDefinedError] if the original functional variable name isn't defined
         # @param [Symbol] original_name the original name of the functional variable
         # @param [Symbol] alias_name the new name of the functional variable
         # @return nil
         def alias_functional_variable(original_name, alias_name)
            define_functional_variable alias_name, &lookup_functional_variable(original_name)
         end

         # calls the defined functional variable proc with the given parameters and
         # returns the result.
         #
         # @raise [FunctionalVariableNotDefinedError] if the named variable doesn't exist
         # @param [Symbol] name the name of the functional variable to evaluate
         # @param [Array] params a list of parameters to pass to the variable
         #                block when calling it
         # @return [Object] the result of  evaluating the functional variable
         def evaluate_functional_variable(name, context, params=[])
            lookup_functional_variable(name).call([context] + params)
         end
         
      end
   end
end