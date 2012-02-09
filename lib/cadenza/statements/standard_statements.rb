
define_statement :load do |context, template|
   context.load_source(template)
end