module Cadenza
  class FilesystemLoader < Loader
    NOT_FOUND_MESSAGE = "Template filename '%s' not found in loading paths: %s"
    
    def self.template_paths
      @@template_paths ||= []
    end
    
    def self.protocol_name
      "Filesystem"
    end
    
    def self.get_template(template)
      # Make sure the template can be found on the load path first, raise an error if it can't
      path = @@template_paths.detect {|path| path_includes_template?(path, template) }
      
      # if the template wasn't on the load path then raise an error
      raise NOT_FOUND_MESSAGE % [template, template_paths.inspect] if path.nil?
      
      # Join the path and the template to get the real filesystem filename
      filename = File.join(path, template)
      
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

  end
end