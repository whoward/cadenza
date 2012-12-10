
module Cadenza
   class Context
      module Stack

         # @!attribute [r] stack
         # @return [Array] the variable stack
         def stack
            @stack ||= []
         end

         # retrieves the value of the given identifier by inspecting the variable
         # stack from top to bottom.  Identifiers with dots in them are separated
         # on that dot character and looked up as a path.  If no value could be 
         # found then nil is returned.
         #
         # @return [Object] the object matching the identifier or nil if not found
         def lookup(identifier)
            sym_identifier = identifier.to_sym

            # if a functional variable is defined matching the identifier name then return that
            return functional_variables[sym_identifier] if functional_variables.has_key?(sym_identifier)

            stack.reverse_each do |scope|
               value = lookup_identifier(scope, identifier)

               return value unless value.nil?
            end
            
            nil
         end

         # assigns the given value to the given identifier at the highest current
         # scope of the stack.
         #
         # @param [String] identifier the name of the variable to store
         # @param [Object] value the value to assign to the given name
         def assign(identifier, value)
            stack.last[identifier.to_sym] = value
         end

         # creates a new scope on the variable stack and assigns the given hash
         # to it.
         #
         # @param [Hash] scope the mapping of names to values for the new scope
         # @return nil
         def push(scope)
            # TODO: symbolizing strings is slow so consider symbolizing here to improve
            # the speed of the lookup method (its more important than push)

            # TODO: since you can assign with the #assign method then make the scope
            # variable optional (assigns an empty hash)
            stack.push(scope)

            nil
         end

         # removes the highest scope from the variable stack
         # @return [Hash] the removed scope
         def pop
            stack.pop
         end

      private
         def lookup_identifier(scope, identifier)
            if identifier.index('.')
               lookup_path(scope, identifier.split("."))
            else
               self.class.lookup_on_object(identifier, scope)
            end
         end

         def lookup_path(scope, path)
            loop do
               component = path.shift

               scope = self.class.lookup_on_object(component, scope)

               return scope if path.empty?
            end
         end

      end
   end
end