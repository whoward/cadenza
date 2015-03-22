require 'stringio'

module RenderingMatcher

   def expect_rendering(document, context, options={})
      output = StringIO.new

      parser = options.fetch(:parser, Cadenza::Parser.new)
      renderer = options.fetch(:renderer, Cadenza::TextRenderer.new(output, :error_handler => lambda {|e| raise e }) )

      document = parser.parse(document) if document.is_a?(String)

      renderer.render(document, context)

      expect(renderer.output.string)
   end

end

RSpec.configure do |config|
   config.include RenderingMatcher
end