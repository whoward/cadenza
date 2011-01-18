module Cadenza
  class InjectNode < Cadenza::Node
    attr_accessor :identifier, :filters
    
    def initialize(identifier,filters,pos)
      super(pos)
      self.identifier = identifier
      self.filters = filters
    end
    
    def implied_globals
      identifier.implied_globals | filters.map(&:params).flatten.map(&:implied_globals).flatten
    end
    
    def render(context={}, stream='')
      
      value = self.identifier.eval(context)
      
      self.filters.each do | ref |
        name = ref.identifier.value
        
        raise TemplateError.new("Filter '%s' is not defined" % name, self) unless Filters.respond_to?(name)
        
        params = Array.new
        ref.params.each { |param| params.push( param.eval(context) ) }
        
        # push the value onto the front of the parameters
        params.unshift(value)
        
        # ensure that the appropriate number of parameters for the filter are provided
         
        if (arity = Cadenza::Filters.method(name).arity) < 0
          sufficient_arguments = params.length >= (arity.abs - 1)
        else
          sufficient_arguments = params.length == arity
        end
        
        raise TemplateError.new("Incorrect number of arguments passed to filter",self) unless sufficient_arguments
        
        # finally send off the request to the filter
        #TODO: reraise exceptions from this send
        value = Filters.send(name, *params)
      end
      
      stream << value.to_s
    end
    
    def ==(rhs)
      super(rhs) and
      self.identifier == rhs.identifier and 
      self.filters == rhs.filters
    end
    
    def to_s
      value = "InjectNode" << TAB << self.identifier.to_s.gsub(/\n/,TAB)
      
      if filters.length > 0
        value << TAB << "<FILTERS>" << TAB
        filters.each do |filter|
          value << filter.identifier.value << TAB
          filter.params.each do | parameter |
            value << "   " << parameter.to_s.gsub(/\n/,TAB).gsub(/\n/,TAB) << TAB
          end
        end
        value.rstrip!
      end
      
      return value
    end
  end
end