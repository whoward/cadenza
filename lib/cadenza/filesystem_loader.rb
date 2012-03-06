
module Cadenza
   # The {FilesystemLoader} is a very simple loader object which takes a given
   # "root" directory and loads templates using the filesystem.  Relative file
   # paths from this directory should be used for template names.
   #
   # This implemenation makes no attempt to be secure so upwards relative file
   # paths could be used to load sensitive files into the output template.
   # 
   # ```django
   #   {# assuming you add /home/someuser as a loaded path #}
   #   {{ load '../../etc/passwd' }}
   # ```
   #
   # If you allow loading to be used for insecure user content then consider
   # using a more secure loader class such as {ZipLoader} or writing a simple
   # loader for your database connection.
   class FilesystemLoader
      # @return [String] the path on the filesystem to load relative to
      attr_accessor :path

      # creates a new {FilesystemLoader} with the given filesystem directory
      # to load templates relative to.
      # @param [String] path see {#path}
      def initialize(path)
         @path = path
      end

      # loads and returns the given template's content or nil if the file was
      # not a file object (such as a directory).
      # @param [String] template the name of the template to load
      # @return [String] the content of the template
      def load_source(template)
         filename = File.join(path, template)

         return unless File.file?(filename)

         File.read filename
      end

      # loads and parses the given template name using {Parser}.  If the template
      # could not be loaded then nil is returned.
      # @param [String] template the name of the template to load
      # @return [DocumentNode] the root node of the parsed AST
      def load_template(template)
         source = load_source(template)

         if source
            return Cadenza::Parser.new.parse(source)
         else
            return nil
         end
      end
   end
end