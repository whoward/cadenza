require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'text nodes' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse text nodes" do
      parser.parse("abc{{def}}ghi").should have_an_identical_syntax_tree_to "text.parse.yml"
   end
end