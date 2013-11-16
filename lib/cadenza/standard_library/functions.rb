require 'cgi'

module Cadenza; end
module Cadenza::StandardLibrary; end

Cadenza::StandardLibrary::Functions = Cadenza::Library.build do
   define_function :load do |context, template|
      params = [template].compact

      expect(params).argc(1).first(:is_a => String)

      context.load_source(template)
   end

   define_function :render do |context, template|
      params = [template].compact

      expect(params).argc(1).first(:is_a => String)

      template = context.load_template(template)

      if template
         Cadenza::TextRenderer.render(template, context)
      else
         ""
      end
   end
end