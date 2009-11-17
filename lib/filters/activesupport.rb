
module Cadenza
  class Filters
    def self.upper_camelize(string)
      string.camelize(:upper)
    end
    
    def self.lower_camelize(string)
      string.camelize(:lower)
    end
    
    #TODO: add more
  end
end