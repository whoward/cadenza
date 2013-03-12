
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
      class Expectation

         def initialize(params)
            @params = params
         end

         def argc(expected)
            pass = case expected
               when Fixnum then params.length == expected
               when Range then expected.include?(params.length)
            end

            raise InvalidArgumentCountError.new(expected, params.length) unless pass

            # return self to allow chaining
            self
         end

         def first(e);   nth(0, e); end
         def second(e);  nth(1, e); end
         def third(e);   nth(2, e); end
         def fourth(e);  nth(3, e); end
         def fifth(e);   nth(4, e); end
         def sixth(e);   nth(5, e); end
         def seventh(e); nth(6, e); end
         def eighth(e);  nth(7, e); end
         def ninth(e);   nth(8, e); end
         def tenth(e);   nth(9, e); end
         # if anyone really expects more than 10 parameters they will just have to use the #nth function

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