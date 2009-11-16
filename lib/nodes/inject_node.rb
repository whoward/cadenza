module Cadenza
  class InjectNode < Cadenza::Node
    attr_accessor :identifier, :filters
    
    def initialize(identifier,filters,pos)
      super(pos)
      self.identifier = identifier
      self.filters = filters
    end
    
    def render(context,stream)
      
      value = self.identifier.eval(context)
      
      self.filters.each do | ref |
        name = ref.identifier.value
        params = Array.new
        ref.params.each { |param| params.push( param.eval(context) ) }
        
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