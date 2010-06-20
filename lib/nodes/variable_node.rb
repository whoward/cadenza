module Cadenza  
  class VariableNode < Cadenza::Node
    attr_accessor :identifier
    
    def initialize(identifier, pos)
      super(pos)
      self.identifier = identifier.value
    end
    
    def render(context, stream)
      stream << self.eval(context).to_s
    end
    
    def eval(context)
      # if the identifier has any number of dots in it we want to split it 
      if not self.identifier.index('.').nil?
        return eval_variable_path(context)
      else
        unless context.has_key?(self.identifier)
          raise TemplateError.new("variable #{self.identifier} is not defined", self)
        end
        
        return context[self.identifier]
      end
    end
    
    def ==(rhs)
      super(rhs) and self.identifier == rhs.identifier
    end
    
    def to_s
      "VariableNode(identifier:#{self.identifier})"
    end
  
  private
    def eval_variable_path(context)
      path = self.identifier.split('.')
        
      unless context.has_key?(path.first)
        raise TemplateError.new("variable #{path.first} is not defined", self)
      end
      
      prev_name = path.shift
      prev      = context[prev_name]
      
      path.each do | name |
        # Determine if the name is a dictionary key of the previous
        if prev.respond_to?('[]')
          result = eval_variable_index(prev, name)
          
          unless result.nil?
            prev = result
            prev_name = name
            next
          end
        end
        
        # It could also be an attribute/method of the object
        if prev.respond_to?(name)
          prev = prev.send(name) #TODO: reraise exceptions from send()
          prev_name = name
          next
        end
        
        # It could also respond to method_missing
        if prev.respond_to?(:method_missing)
          prev = prev.send(:method_missing, name)
          prev_name = name
          next
        end
        
        raise TemplateError.new("#{name} is not defined for #{prev_name}", self)
      end
      
      return prev
    end
    
    def eval_variable_index(prev, name)
      return nil if prev.class == Array and not name =~ /\d+/
      array_index = (prev.class == Array) ? name.to_i : name
      return prev[array_index]
    end
    
  end
end