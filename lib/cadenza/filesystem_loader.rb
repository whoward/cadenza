
module Cadenza
   class FilesystemLoader
      attr_accessor :path

      def initialize(path)
         @path = path
      end

      def load_template(template)
         filename = File.join(path, template)

         return unless File.file?(filename)

         Cadenza::Parser.new.parse(File.read filename)
      end
   end
end