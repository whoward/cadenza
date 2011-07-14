  
module Cadenza
  class Token < Struct.new(:value, :source, :line, :column)
  end
end