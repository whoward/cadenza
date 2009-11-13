module Cadenza  
  class VariableNode < Cadenza::Node
    attr_accessor :identifier
    
    def initialize(identifier, line, col)
      super(line,col)
      self.identifier = identifier
    end
    
    def render(context, stream)
      stream << self.eval(context).to_s
    end
    
    def eval(context)
      # if the identifier has any number of dots in it we want to split it 
      if not self.identifier.index('.').nil?
        path = self.identifier.split('.')
        
        unless context.has_key?(path.first)
          raise TemplateError.new("variable #{path.first} is not defined", self)
        end
        
        prev_name = path.shift
        prev      = context[prev_name]
        
        path.each do | name |
          # Determine if the name is a dictionary key of the previous
          if prev.respond_to?('[]') and not prev[name].nil?
            prev = prev[name]
            prev_name = name
           
          # It could also be an attribute/method of the object
          elsif prev.respond_to?(name)
            prev = prev.send(name) #TODO: reraise exceptions from send()
            prev_name = name
            
          else
            raise TemplateError.new("#{name} is not defined for #{prev_name}", self)
                                
          end
        end
        
        return prev
        
      else
        unless context.has_key?(self.identifier)
          raise TemplateError.new("variable #{self.identifier} is not defined", self)
        end
        
        return context[self.identifier]
      end
    end
    
    def to_s
      "VariableNode(identifier:#{self.identifier})"
    end
    
  end
end