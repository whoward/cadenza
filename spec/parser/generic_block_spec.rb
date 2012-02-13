require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'generic block statements' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse a generic block" do
      ast = parser.parse("{% example %}foobar{% end %}")
      ast.should have_an_identical_syntax_tree_to "generic-block.parse.yml"
   end

   it "should parse a generic block with parameters" do
      ast = parser.parse("{% filter escape %}<h1>Hello World!</h1>{% end %}")
      ast.should have_an_identical_syntax_tree_to "generic-block-with-params.parse.yml"
   end

end