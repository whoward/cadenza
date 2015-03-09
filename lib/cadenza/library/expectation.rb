
module Cadenza
   class InvalidArgumentCountError < Cadenza::Error
      def initialize(expected_count, actual_count)
         super "wrong number of arguments (#{actual_count} for #{expected_count})"
      end
   end

   class InvalidArgumentTypeError < Cadenza::Error
      def initialize(expected, actual)
         super "expected #{expected} but got #{actual}"
      end
   end

   module Library

      # The {Expectation} class is a utility to evaluate numerous expectations
      # against a list of passed parameters.  This is intended to be used by 
      # library functions to validate their parameters before evaluating them,
      # resulting in a easily handled Cadenza::Error rather than a ruby 
      # StandardError or similar.
      #
      class Expectation

         # constructs a new {Expectation} for the given parameters.
         # @param [Array] params the list of parameters to evaluate expectations against
         def initialize(params)
            @params = params
         end

         # evaluates an expectation against the number of parameters passed
         # 
         # @raise [InvalidArgumentCountError] when the number of parameters does 
         #        not match the expectation passed
         # @param [Fixnum|Range] expected when given a {Fixnum} the number of 
         #        parameters must match the number given, when given a {Range}
         #        the number of parameters be included in the range (inclusive)
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def argc(expected)
            pass = case expected
               when Fixnum then params.length == expected
               when Range then expected.include?(params.length)
            end

            raise InvalidArgumentCountError.new(expected, params.length) unless pass

            # return self to allow chaining
            self
         end

         # alias for the method {#nth} with idx=0
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def first(*args);   nth(0, *args); end

         # alias for the method {#nth} with idx=1
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def second(*args);  nth(1, *args); end

         # alias for the method {#nth} with idx=2
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def third(*args);   nth(2, *args); end

         # alias for the method {#nth} with idx=3
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def fourth(*args);  nth(3, *args); end

         # alias for the method {#nth} with idx=4
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def fifth(*args);   nth(4, *args); end

         # alias for the method {#nth} with idx=5
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def sixth(*args);   nth(5, *args); end

         # alias for the method {#nth} with idx=6
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def seventh(*args); nth(6, *args); end

         # alias for the method {#nth} with idx=7
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def eighth(*args);  nth(7, *args); end

         # alias for the method {#nth} with idx=8
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def ninth(*args);   nth(8, *args); end

         # alias for the method {#nth} with idx=9
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def tenth(*args);   nth(9, *args); end

         # evaluates the given expectations against the indexed parameter
         #
         # @raise [InvalidArgumentTypeError] if a argument type expectation is passed but not satisfied
         # @param [Fixnum] idx the index of the parameter to evaluate against
         # @param [Hash] e
         # @option e [Class] :is_a a class expectation that will fail if the argument passed is not an instance of the class
         # @return [Expectation] returns the 'self' object to facilitate chaining
         def nth(idx, e)
            # do no validations if insufficient parameters are given (the argc validation is used for that)
            return if idx > (params.length - 1)

            val = params[idx]

            raise InvalidArgumentTypeError.new(e[:is_a], val.class) if e.has_key?(:is_a) && !val.is_a?(e[:is_a])

            # return self to allow chaining
            self
         end

      private

         attr_reader :params

      end
   end
end