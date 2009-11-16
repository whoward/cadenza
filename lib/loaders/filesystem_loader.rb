module Cadenza
  class FilesystemLoader < Loader
    NOT_FOUND_MESSAGE = "Template filename '%s' not found in loading paths: %s"
    
    def self.template_paths
      @@template_paths ||= []
    end
    
    def self.protocol_name
      "Filesystem"
    end
    
    def self.get_template(address)
      # Make sure the address can be found on the load path first, raise an error if it can't
      path = @@template_paths.detect(raise_error(NOT_FOUND_MESSAGE, address, template_paths.inspect)) do | x |
        path_includes_template?(x, address)
      end
      
      # Join the path and the address to get the real filesystem filename
      filename = File.join(path, address)
      
      # Check the cache to see if the file has already been loaded and parsed, if not then
      # load and parse.  Finally return the parsed template.
      Loader.loaded_templates.fetch(filename) do
        template = Loader.parser.parse(File.open(filename).read)
      end
    end
    

    
    def self.path_includes_template?(path, template)
      filename = File.join(path, template)
      
      return false unless File.exists?(filename)
      
      return true
      #TODO: check if the filename is UNDER the current path
    end
    
  private
    def self.raise_error(message, *args)
      Proc.new { raise LoadingError.new(message % args) }
    end
  end
end