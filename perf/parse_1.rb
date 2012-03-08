#!/usr/bin/env ruby
require File.expand_path('perf_helper', File.dirname(__FILE__))

cadenza_parser = Cadenza::Parser.new
cadenza_template_data = cadenza_template_data("template_1")

liquid_parser = Liquid::Template
liquid_template_data = liquid_template_data("template_1")

puts "benchmarking parsing of template_1"
Benchmark.bmbm do |b|
   b.report "parsing with Cadenza" do
      10_000.times { cadenza_parser.parse(cadenza_template_data) }
   end

   b.report "parsing with Liquid" do
      10_000.times { liquid_parser.parse(liquid_template_data) }
   end
end