require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'variable nodes' do
   let(:parser) { Cadenza::Parser.new }

   it "parses an identifier token into a variable node" do
      parser.parse("{{ foo }}").should have_an_identical_syntax_tree_to "variable/basic.yml"
   end
   
   context "inject with filters" do
      it "should parse an inject statement with one filter" do
         ast = parser.parse('{{ name | trim }}')
         ast.should have_an_identical_syntax_tree_to "variable/one-filter.yml"
      end

      it "should parse an inject statement with multiple filters" do
         ast = parser.parse("{{ name | trim | upcase }}")
         ast.should have_an_identical_syntax_tree_to "variable/multiple-filters.yml"
      end
   end

   context "inject with filters and multiple params" do
      it "should parse a single param" do
         ast = parser.parse("{{ name | cut: 5 }}")
         ast.should have_an_identical_syntax_tree_to "variable/one-filter-with-params.yml"
      end

      it "should parse multiple params" do
         ast = parser.parse("{{ name | somefilter: 'foo', 3.14159 }}")
         ast.should have_an_identical_syntax_tree_to "variable/one-filter-with-multiple-params.yml"
      end
   end

   context "inject with multiple filters and multiple params" do
      it "should parse multiple filters with mixed params" do
         ast = parser.parse("{{ name | trim | somefilter: 'foo', 3.14159 }}")
         ast.should have_an_identical_syntax_tree_to "variable/multiple-filter-multiple-params.yml"
      end

   end

   context "functional inject statements" do
      it "should parse one" do
         ast = parser.parse("{{ load 'mytemplate' }}")
         ast.should have_an_identical_syntax_tree_to "variable/functional.yml"
      end

      it "should parse one with complex params" do
         ast = parser.parse("{{ load 'mytemplate', x + 123 }}")
         ast.should have_an_identical_syntax_tree_to "variable/functional-multiple-params.yml"
      end

   end

   context "functional inject statements with filters" do
      it "should parse it" do
         ast = parser.parse("{{ load 'mytemplate' | htmlescape }}")
         ast.should have_an_identical_syntax_tree_to "variable/functional-with-filters.yml"
      end

      it "should parse a very complex functional inject" do
         ast = parser.parse("{{ load 'mytemplate', x + 123 | htmlescape | wordwrap: 20 }}")
         ast.should have_an_identical_syntax_tree_to "variable/functional-with-param-filters.yml"
      end
   end


end