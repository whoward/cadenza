require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'generic block statements' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse a generic block" do
      ast = parser.parse("{% example %}foobar{% end %}")
      ast.should have_an_identical_syntax_tree_to "generic/basic.yml"
   end

   it "should parse a generic block with parameters" do
      ast = parser.parse("{% filter escape %}<h1>Hello World!</h1>{% end %}")
      ast.should have_an_identical_syntax_tree_to "generic/with-params.yml"
   end

end