require 'cgi'
#
# This hash is the context that will be used for all the documentation pages
#
push({
  'alphabet' => ('A'..'Z').to_a,
  'now' => Time.now,
  'nil' => nil,
  'empty_list' => [],
  'name' => 'John Doe',
  'something_true' => true,
  'something_false' => false,
  'lorem_ipsum' => "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
})

define_statement :example do |context, template|
  result = "<div class='example'>"

  result << "<pre class='source'>"
  result << context.evaluate_statement("load", [template])
  result << "</pre>"

  result << "<pre class='rendered'>"
  result << context.evaluate_statement("render", [template])
  result << "</pre>"

  result << "</div>"

  result
end

define_block :code_example do |context, nodes, parameters|
  result = "<pre>"
  nodes.each do |node|
    result << CGI.escapeHTML(Cadenza::TextRenderer.render(node, context))
  end
  result << "</pre>"
  result
end
