
module Cadenza
   FilterNotDefinedError = Class.new(Cadenza::Error)

   class Context
      module Filters

         # @return [Hash] the filter names mapped to their implementing procs
         def filters
            @filters ||= {}
         end

         def filters=(rhs)
            @filters = rhs
         end

         # defines a filter proc with the given name
         #
         # @param [Symbol] name the name for the template to use for this filter
         # @yield [String, *args] the block will receive the input string and a 
         #                        variable number of arguments passed to the filter.
         # @return nil
         def define_filter(name, &block)
            filters[name.to_sym] = block
            nil
         end

         def alias_filter(original_name, alias_name)
            filter = filters[original_name.to_sym]
            raise FilterNotDefinedError.new("undefined filter '#{original_name}'") if filter.nil?
            filters[alias_name.to_sym] = filter
         end

         # calls the defined filter proc with the given parameters and returns the
         # result.  
         #
         # @raise [FilterNotDefinedError] if the named filter doesn't exist
         # @param [Symbol] name the name of the filter to evaluate
         # @param [Array] params a list of parameters to pass to the filter 
         #                block when calling it.
         # @return [String] the result of evaluating the filter
         def evaluate_filter(name, params=[])
            filter = filters[name.to_sym]
            raise FilterNotDefinedError.new("undefined filter '#{name}'") if filter.nil?
            filter.call(*params)
         end


      end
   end
end