#!/usr/bin/env ruby
require File.expand_path('../perf_helper', File.dirname(__FILE__))

lexer = Cadenza::Lexer.new
template = cadenza_template_data("template_1")

Benchmark.bmbm do |b|
   b.report "tokenizing with cadenza" do
      10_000.times do
         lexer.source = template
         lexer.remaining_tokens
      end
   end
end

