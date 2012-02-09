
module Cadenza
   class FilesystemLoader
      attr_accessor :path

      def initialize(path)
         @path = path
      end

      def load_source(template)
         filename = File.join(path, template)

         return unless File.file?(filename)

         File.read filename
      end

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