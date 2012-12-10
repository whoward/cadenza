
module Cadenza
   FunctionalVariableNotDefinedError = Class.new(Cadenza::Error)

   class Context
      module FunctionalVariables
         
         # @return [Hash] the functional variable names mapped to their implementing procs
         def functional_variables
            @functional_variables ||= {}
         end

         def functional_variables=(rhs)
            @functional_variables = rhs
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

         def alias_functional_variable(original_name, alias_name)
            var = functional_variables[original_name.to_sym]
            raise FunctionalVariableNotDefinedError.new("undefined functional variable '#{original_name}'") if var.nil?
            functional_variables[alias_name.to_sym] = var
         end

         # calls the defined functional variable proc with the given parameters and
         # returns the result.
         #
         # @raise [FunctionalVariableNotDefinedError] if the named variable doesn't exist
         # @param [Symbol] name the name of the functional variable to evaluate
         # @param [Array] params a list of parameters to pass to the variable
         #                block when calling it
         # @return [Object] the result of  evaluating the functional variable
         def evaluate_functional_variable(name, params=[])
            var = functional_variables[name.to_sym]
            raise FunctionalVariableNotDefinedError.new("undefined functional variable '#{name}'") if var.nil?
            var.call([self] + params)
         end
         
      end
   end
end