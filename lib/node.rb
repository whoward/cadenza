
module Cadenza
  class TemplateError < StandardError
    def initialize(message,node)
      super(message << " on line #{node.line}, column #{node.column}")
    end
  end

  class Node
    attr_accessor :line, :column
    
    def initialize(token)
      super()
      self.line = token.line
      self.column = token.column
    end
  
    def render(context={}, stream='')
       raise 'Unimplemented method: render'
    end
    
    def implied_globals
      raise 'Unimplemented method: implied_globals'
    end
    
    # tests for equality of the two nodes, we dont count the line and column attributes for equality
    def ==(rhs)
      self.class == rhs.class
    end
   
  protected
    # this is used for each node's to_s method, to keep the indentation consistent
    TAB_SPACES = 3
    TAB = "\n" << " " * TAB_SPACES
    
  end
end

# require all the files in the nodes directory
Dir.glob(File.join(File.dirname(__FILE__), 'nodes/*.rb')).each {|f| require f }