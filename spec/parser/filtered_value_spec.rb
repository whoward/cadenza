require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'filtered value nodes' do
   let(:parser) { Cadenza::Parser.new }

   it "parses an inject statement with one filter" do
      ast = parser.parse('{{ name | trim }}')
      ast.should have_an_identical_syntax_tree_to "filtered_value/single_filter.yml"
   end

   it "parses an inject statement with multiple filters" do
      ast = parser.parse("{{ name | trim | upcase }}")
      ast.should have_an_identical_syntax_tree_to "filtered_value/multiple_filters.yml"
   end

   it "parses a single param" do
      ast = parser.parse("{{ name | cut: 5 }}")
      ast.should have_an_identical_syntax_tree_to "filtered_value/single_filter_with_single_param.yml"
   end

   it "parses multiple params" do
      ast = parser.parse("{{ name | somefilter: 'foo', 3.14159 }}")
      ast.should have_an_identical_syntax_tree_to "filtered_value/single_filter_with_multiple_params.yml"
   end

   it "parses multiple filters with multiple params" do
      ast = parser.parse("{{ name | trim | somefilter: 'foo', 3.14159 }}")
      ast.should have_an_identical_syntax_tree_to "filtered_value/multiple_filters_with_params.yml"
   end
end