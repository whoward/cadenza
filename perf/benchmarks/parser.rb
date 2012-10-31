#!/usr/bin/env ruby
require File.expand_path('../perf_helper', File.dirname(__FILE__))

lexer = Cadenza::Lexer.new
lexer.source = cadenza_template_data("template_1")

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

Benchmark.bmbm do |b|
   b.report "parsing with cadenza" do
      10_000.times do
         parser.parse(nil)
      end
   end
end
