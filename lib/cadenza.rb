require 'cadenza/error'
require 'cadenza/token'
require 'cadenza/lexer'
require 'cadenza/racc_parser'
require 'cadenza/parser'
require 'cadenza/context'
require 'cadenza/context_object'
require 'cadenza/base_renderer'
require 'cadenza/text_renderer'
require 'cadenza/filesystem_loader'
require 'cadenza/version'

require 'stringio'

# require all nodes
Dir[File.join File.dirname(__FILE__), 'cadenza', 'nodes', '*.rb'].each {|f| require f }

module Cadenza
   BaseContext = Context.new

   # this utility method sets up the standard Cadenza lexer/parser/renderer 
   # stack and renders the given template text with the given variable scope
   # using the {BaseContext}.  the result of rendering is returned as a string.
   #
   # @param [String] template_text the content of the template to parse/render
   # @param [Hash] scope any variables to define as a new scope for {BaseContext}
   #               in this template.
   def self.render(template_text, scope=nil)
      template = Parser.new.parse(template_text)

      context = BaseContext.clone

      context.push(scope) if scope

      output = StringIO.new

      TextRenderer.new(output).render(template, context)

      output.string
   end

   # similar to {#render} except the given template name will be loaded using
   # {BaseContext}s predefined list of loaders.
   #
   # @param [String] template_name the name of the template to load then parse and render
   # @param [Hash] scope any variables to define as a new scope for {BaseContext}
   #               in this template.
   def self.render_template(template_name, scope=nil)
      context = BaseContext.clone

      context.push(scope) if scope

      template = context.load_template(template_name)

      output = StringIO.new
      
      TextRenderer.new(output).render(template, context)

      output.string
   end
end

Dir[File.join File.dirname(__FILE__), 'cadenza', 'filters', '*.rb'].each do |filename|
   Cadenza::BaseContext.instance_eval File.read(filename)
end

Dir[File.join File.dirname(__FILE__), 'cadenza', 'functional_variables', '*.rb'].each do |filename|
   Cadenza::BaseContext.instance_eval File.read(filename)
end

Dir[File.join File.dirname(__FILE__), 'cadenza', 'blocks', '*.rb'].each do |filename|
   Cadenza::BaseContext.instance_eval File.read(filename)
end