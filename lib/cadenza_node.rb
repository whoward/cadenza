
module Cadenza
  class TemplateError < StandardError
    def initialize(message,node)
      super(message << " on line #{node.line}, column #{node.column}")
    end
  end
  
  #TODO: i think at least the render() method should be thread safe, it may be anyways if it is read-only
  class Node
    attr_accessor :line, :column
    
    def initialize(line,col)
      super()
      self.line = line
      self.column = col 
    end
  
    def render(context,stream)
       raise 'Unimplemented evaluation'
    end
   
  protected
    # this is used for each node's to_s method 
    TAB_SPACES = 3
    TAB = "\n" << " " * TAB_SPACES
    
  end
end

# require all the files in the nodes directory
Dir.glob(File.join(File.dirname(__FILE__), 'nodes/*.rb')).each {|f| require f }