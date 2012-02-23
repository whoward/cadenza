require 'cgi'
require 'pygments'

def example(context, template)
  result = "<div class='example'>"

  result << "<pre class='source'>"
  result << CGI::escapeHTML(context.evaluate_functional_variable("load", [template]))
  result << "</pre>"

  result << "<pre class='rendered'>"
  result << CGI::escapeHTML(context.evaluate_functional_variable("render", [template]))
  result << "</pre>"

  result << "</div>"

  result  
end

def code_example(context, nodes, parameters)
  result = "<pre>"
  nodes.each do |node|
    result << CGI.escapeHTML(Cadenza::TextRenderer.render(node, context))
  end
  result << "</pre>"
  result  
end

def highlighted_example(context, template, lexer)
  source = context.evaluate_functional_variable("load", [template])

  Pygments.highlight(source, :lexer => lexer)
end

def ruby_example(context, template)
  highlighted_example context, template, "ruby"
end

def irb_example(context, template)
  highlighted_example context, template, "irb"
end

def cadenza_example(context, template)
  highlighted_example context, template, "django"
end

def rendering_example(context, template)
  source = context.evaluate_functional_variable("load", [template])
  output = context.evaluate_functional_variable("render", [template])

  result = "<div class='example'>"
  result << Pygments.highlight(source, :lexer => "django")
  result << Pygments.highlight(output, :lexer => "html")
  result << "</div>"

  result
end

whiny_template_loading = true

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

define_functional_variable :example, &method(:example)
define_functional_variable :ruby_example, &method(:ruby_example)
define_functional_variable :irb_example, &method(:irb_example)
define_functional_variable :rendering_example, &method(:rendering_example)
define_functional_variable :cadenza_example, &method(:cadenza_example)

define_block :code_example, &method(:code_example)
