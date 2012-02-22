  
module Cadenza
   class Token < Struct.new(:value, :source, :line, :column)
      #TODO: make helpers for building tokens
   end
end