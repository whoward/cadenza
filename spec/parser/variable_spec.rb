require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'variable nodes' do
   let(:parser) { Cadenza::Parser.new }

   it "parses an identifier token into a variable node" do
      parser.parse("{{ foo }}").should have_an_identical_syntax_tree_to "variable/basic.yml"
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

end