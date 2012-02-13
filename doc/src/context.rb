require 'cgi'
#
# This hash is the context that will be used for all the documentation pages
#
push({
  'alphabet' => ('A'..'Z').to_a,
  'now' => Time.now,
  'nil' => nil,
  'empty_list' => [],
})

define_block :code_example do |context, nodes, parameters|
   result = "<pre>"
   nodes.each do |node|
      result << CGI.escapeHTML(Cadenza::TextRenderer.render(node, context))
   end
   result << "</pre>"
   result
end
