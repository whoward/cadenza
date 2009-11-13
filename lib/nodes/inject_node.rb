module Cadenza
  class Filters
    def self.upper(string)
      return string.upcase
    end
  end
  
  class InjectNode < Cadenza::Node
    attr_accessor :identifier, :filters
    
    def initialize(identifier,filters,line,col)
      super(line,col)
      self.identifier = identifier
      self.filters = filters
    end
    
    def render(context,stream)
      
      value = self.identifier.eval(context)
      
      self.filters.each do | name, params |
        raise TemplateError.new("Filter '%s' is not defined" % name, self) unless Filters.respond_to?(name)
        
        #TODO: reraise exceptions from this send
        value = Filters.send(name, *params.unshift(value))
      end
      
      stream << value.to_s
    end
    
    def to_s
      value = "InjectNode" << TAB << self.identifier.to_s.gsub(/\n/,TAB)
      
      if filters.length > 0
        value << TAB << "<FILTERS>" << TAB
        filters.each do |filter|
          value << filter[0] << TAB
          filter[1].each do | parameter |
            value << "   " << format_value(parameter).gsub(/\n/,TAB) << TAB
          end
        end
        value.rstrip!
      end
      
      return value
    end
  
  end
end