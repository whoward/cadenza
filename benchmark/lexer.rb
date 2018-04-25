#!/usr/bin/env ruby
require_relative 'perf_helper'

lexer = Cadenza::Lexer.new
template = DATA.read.freeze

10_000.times do
   lexer.source = template
   lexer.remaining_tokens
end

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
