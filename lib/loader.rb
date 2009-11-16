module Cadenza
  class LoadingError < StandardError
  end
  
  class Loader
    # Returns the parser currently being used by the loader class
    def self.parser
      @@parser ||= Parser.new
    end
    
    # Sets the parser to be used by the loader class.  Note this will not recompile templates that
    # have already been loaded.  To force recompilation you will have to clear the loaded_templates
    # hash and reload the files manually.
    def self.parser=(parser)
      @@parser = parser
    end
    
    # Keep track of the classes that subclass this one
    def self.inherited(subclass)
      (@@protocol_classes ||= Array.new).push(subclass)
    end
    
    # Returns a hash of all protocol names to the class that implements them. 
    def self.protocols
      protocol_hash.freeze
    end
        
    # Returns a hash of [protocol, address] to the parsed templates that have already been loaded.
    # Note: to render templates you should not reference this method as it provides no validation.
    # Instead make use of get_template, which will check to see if the loaded template is still
    # valid.
    def self.loaded_templates
      @@loaded_templates ||= Hash.new
    end
    
    # Retrieves the parsed template for a given protocol and address. If the template has not
    # already been loaded before then it will retrieve the template using the address, parse it
    # and then cache it.
    def self.get_template(protocol, address)
      klass = protocols.fetch(protocol)
      
      template = klass.get_template(address)
      
      unless loaded_templates.has_key?([protocol, address])
        loaded_templates.store([protocol, address], template)
      end
      
      return template
    end
    
    # Returns the protocol name for the loader
    def self.protocol_name
      raise 'unimplemented protocol_name'
    end
  
  private
    def self.protocol_hash
      result = Hash.new
      @@protocol_classes.each {|elem| result.store(elem.protocol_name, elem)}
      return result
    end
    
  end
end

# require all the files in the loaders directory
Dir.glob(File.join(File.dirname(__FILE__), 'loaders/*.rb')).each {|f| require f }