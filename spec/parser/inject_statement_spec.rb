require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'inject statements' do
   let(:parser) { Cadenza::Parser.new }
   
   it "parses inject statement" do
      ast = parser.parse('{{somevar}}')
      ast.should have_an_identical_syntax_tree_to "inject/basic.yml"
   end

end
