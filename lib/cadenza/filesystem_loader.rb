
module Cadenza
   class FilesystemLoader
      attr_accessor :path

      def initialize(path)
         @path = path
         @security_glob = File.join(@path, "*")
      end

      def load_template(template)
         filename = File.join(path, template)

         return unless File.file?(filename) and File.fnmatch?(@security_glob, File.realpath(filename))

         Cadenza::Parser.new.parse(File.read filename)
      end
   end
end