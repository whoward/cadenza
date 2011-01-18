module Cadenza
  class GenericStatementNode < Node
    attr_accessor :statement_name, :parameters
    
    def initialize(statement_name, parameters, pos)
      super(pos)
      self.statement_name = statement_name
      self.parameters = parameters
    end
    
    def implied_globals
      parameters.map(&:implied_globals).flatten.uniq
    end
    
    def render(context={}, stream='')
      name = self.statement_name.value
      
      params = Array.new
      self.parameters.each {|p| params.push( p.eval(context) )}
      
      raise TemplateError.new("Statement '%s' is not defined" % name, self) unless Statements.respond_to?(name)
      
      # ensure that the appropriate number of parameters for the statement are provided         
      if (arity = Statements.method(name).arity) < 0
        sufficient_arguments = params.length >= (arity.abs - 1)
      else
        sufficient_arguments = params.length == arity
      end
        
      raise TemplateError.new("Incorrect number of arguments passed to filter",self) unless sufficient_arguments
        
      # send off the method call to the statement
      #TODO: reraise exceptions from this send
      value = Statements.send(name, *params)
      
      # write the response back to the output stream and return it
      stream << value.to_s
      return value.to_s
    end
    
    def ==(rhs)
      super(rhs) and
      self.statement_name == rhs.statement_name and
      self.paramters == rhs.parameters
    end
  end
end