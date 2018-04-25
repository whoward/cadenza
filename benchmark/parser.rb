#!/usr/bin/env ruby
require_relative 'perf_helper'

lexer = Cadenza::Lexer.new
lexer.source = DATA.read.freeze

# pre-tokenize the template so that we aren't counting the lexer's performance
tokens = lexer.remaining_tokens

class FakeLexer
   def initialize(tokens)
      @tokens = tokens
   end

   def source=(src)
      @index = 0
   end

   def next_token
      value = @tokens[@index]

      @index += 1

      value || [false, false]
   end
end

parser = Cadenza::Parser.new(:lexer => FakeLexer.new(tokens))

10_000.times { parser.parse(nil) }

__END__
<html>
   <head>
      <title>{{ title | upcase }}</title>

      {{ "style.css" | css_asset }}

      {{ "jquery.js" | javascript_asset }}
      {{ "ember.js" | javascript_asset }}
   </head>
   <body>
      <h1>This is my awesome page!</h1>

      {% if records.length > 0 %}
         You got some records!
      {% endif %}

      {% for record in records %}
         {{ record }}
      {% endfor %}
   </body>
</html>
