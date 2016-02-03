
module Cadenza
   TemplateNotFoundError = Class.new(Cadenza::Error)

   class Context
      module Loaders

         # @!attribute [rw] whiny_template_loading
         # @return [Boolean] true if a {TemplateNotFoundError} should still be
         #                   raised if not calling the bang form of {#load_source}
         #                   or {#load_template}
         def whiny_template_loading
            @whiny_template_loading ||= false
         end

         def whiny_template_loading=(rhs)
            @whiny_template_loading = rhs
         end

         # @!attribute [r] loaders
         # @return [Array] the list of loaders
         def loaders
            @loaders ||= []
         end

         # constructs a {FilesystemLoader} with the string given as its path and
         # adds the loader to the end of the loader list.
         #
         # @param [String] path to use for loader
         # @return [Loader] the loader that was created
         def add_load_path(path)
           loader = FilesystemLoader.new(path)
           add_loader(loader)
           loader
         end

         # adds the given loader to the end of the loader list.
         #
         # @param [Loader] loader the loader to add
         # @return nil
         def add_loader(loader)
            loaders.push loader
            nil
         end

         # removes all loaders from the context
         # @return nil
         def clear_loaders
            loaders.reject! { true }
            nil
         end

         # loads and returns the given template but does not parse it
         #
         # @raise [TemplateNotFoundError] if {#whiny_template_loading} is enabled and
         #                                the template could not be loaded.
         # @param [String] template_name the name of the template to load
         # @return [String] the template text or nil if the template could not be loaded
         def load_source(template_name)
            source = nil

            loaders.each do |loader|
               source = loader.load_source(template_name)
               break if source
            end

            fail TemplateNotFoundError, template_name if source.nil? && whiny_template_loading
            
            source
         end

         # loads and returns the given template but does not parse it
         #
         # @raise [TemplateNotFoundError] if the template could not be loaded
         # @param [String] template_name the name of the template to load
         # @return [String] the template text
         def load_source!(template_name)
            load_source(template_name) || raise(TemplateNotFoundError.new(template_name))
         end

         # loads, parses and returns the given template
         #
         # @raise [TemplateNotFoundError] if {#whiny_template_loading} is enabled and
         #                                the template could not be loaded.
         # @param [String] template_name the name of the template to load
         # @return [DocumentNode] the root of the parsed document or nil if the 
         #                          template could not be loaded.
         def load_template(template_name)
            template = nil

            loaders.each do |loader|
               template = loader.load_template(template_name)
               break if template
            end
            
            fail TemplateNotFoundError, template_name if template.nil? && whiny_template_loading
            
            template
         end

         # loads, parses and returns the given template
         #
         # @raise [TemplateNotFoundError] if the template could not be loaded
         # @param [String] template_name the name of the template ot load
         # @return [DocumentNode] the root of the parsed document
         def load_template!(template_name)
            load_template(template_name) || raise(TemplateNotFoundError.new(template_name))
         end

      end
   end
end