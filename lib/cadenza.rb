require 'cadenza/token'
require 'cadenza/lexer'
require 'cadenza/parser'
require 'cadenza/context'
require 'cadenza/base_renderer'
require 'cadenza/text_renderer'
require 'cadenza/filesystem_loader'
require 'cadenza/version'

require 'stringio'

# require all nodes
Dir[File.join File.dirname(__FILE__), 'cadenza', 'nodes', '*.rb'].each {|f| require f }

module Cadenza
   BaseContext = Context.new

   def self.render(template_text, scope=nil)
      template = Parser.new.parse(template_text)

      context = BaseContext.clone

      context.push(scope) if scope

      output = StringIO.new

      TextRenderer.new(output).render(template, context)

      output.string
   end

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