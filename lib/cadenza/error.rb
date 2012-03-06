module Cadenza
   # The {Error} class is the base class of all types of errors Cadenza will
   # raise, this should make exception handling much simpler for you.
   #
   # Example:
   #    begin
   #       Cadenza.parse("some {{ invalid template")
   #    rescue Cadenza::Error => e
   #       puts "oh noes!"
   #    end
   class Error < StandardError
   end
end