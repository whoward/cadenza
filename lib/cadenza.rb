require 'cadenza/error'

require 'cadenza/token'

require 'cadenza/lexer'

require 'cadenza/racc_parser'
require 'cadenza/parser'

require 'cadenza/library'
require 'cadenza/standard_library'

require 'cadenza/context'
require 'cadenza/base_context'

require 'cadenza/context_object'

require 'cadenza/base_renderer'
require 'cadenza/text_renderer'
require 'cadenza/source_renderer'

require 'cadenza/filesystem_loader'

require 'cadenza/version'

require 'stringio'

# require all nodes
Dir[File.join File.dirname(__FILE__), 'cadenza', 'nodes', '*.rb'].each {|f| require f }

module Cadenza
   # this utility method sets up the standard Cadenza lexer/parser/renderer 
   # stack and renders the given template text with the given variable scope
   # using the {BaseContext}.  the result of rendering is returned as a string.
   #
   # @param [String] template_text the content of the template to parse/render
   # @param [Hash] scope any variables to define as a new scope for {BaseContext}
   #               in this template.
   def self.render(template_text, scope=nil, options={})
      context = create_context(scope, options)

      do_render(Parser.new.parse(template_text), context)
   end

   # similar to {#render} except the given template name will be loaded using
   # {BaseContext}s predefined list of loaders.
   #
   # @param [String] template_name the name of the template to load then parse and render
   # @param [Hash] scope any variables to define as a new scope for {BaseContext}
   #               in this template.
   def self.render_template(template_name, scope=nil, options={})
      context = create_context(scope, options)

      do_render(context.load_template(template_name), context)
   end

   private

   def self.create_context(scope, options)
      context = options.fetch(:context) { BaseContext.new }

      context.push(scope) if scope

      context
   end

   def self.do_render(template, context)
      output = StringIO.new

      TextRenderer.new(output).render(template, context)

      output.string
   end
end