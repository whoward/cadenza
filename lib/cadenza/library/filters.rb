
module Cadenza
   FilterNotDefinedError = Class.new(Cadenza::Error)

   module Library
      module Filters

         # @!attribute [r] filters
         # @return [Hash] the filter names mapped to their implementing procs
         def filters
            @filters ||= {}
         end

         # looks up the filter by name
         # 
         # @raise [FilterNotDefinedError] if the filter can not be found
         # @param [Symbol] name the name of the filter to look up
         # @return [Proc] the filter implementation
         def lookup_filter(name)
            filters.fetch(name.to_sym) { raise FilterNotDefinedError.new("undefined filter '#{name}'") }
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

         # creates an alias of the given filter name under a different name 
         #
         # @raise [FilterNotDefinedError] if the original filter name isn't defined
         # @param [Symbol] original_name the original name of the filter
         # @param [Symbol] alias_name the new name of the filter
         # @return nil
         def alias_filter(original_name, alias_name)
            define_filter alias_name, &lookup_filter(original_name)
         end

         # calls the defined filter proc with the given parameters and returns the
         # result.  
         #
         # @raise [FilterNotDefinedError] if the named filter doesn't exist
         # @param [Symbol] name the name of the filter to evaluate
         # @param [Object] input the input value which will be filtered
         # @param [Array] params a list of parameters to pass to the filter 
         #                block when calling it.
         # @return [String] the result of evaluating the filter
         def evaluate_filter(name, input, params=[])
            lookup_filter(name).call(input, params)
         end


      end
   end
end