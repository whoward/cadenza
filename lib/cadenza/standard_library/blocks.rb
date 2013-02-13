require 'cgi'

module Cadenza; end
module Cadenza::StandardLibrary; end

Cadenza::StandardLibrary::Blocks = Cadenza::Library.build do

   define_block :filter do |context, nodes, parameters|
      filter = parameters.first.identifier

      nodes.inject("") do |output, child|
         node_text = Cadenza::TextRenderer.render(child, context)
         output << context.evaluate_filter(filter, node_text)
      end
   end

end