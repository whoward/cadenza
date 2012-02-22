
define_functional_variable :load do |context, template|
   context.load_source(template)
end

define_functional_variable :render do |context, template|
   template = context.load_template(template)

   if template
      Cadenza::TextRenderer.render(template, context)
   else
      ""
   end
end