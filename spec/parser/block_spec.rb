require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'block parsing' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse block blocks" do
      parser.parse("{% block foo %}bar{% endblock %}").should have_an_identical_syntax_tree_to "block/basic.yml"
   end

   it "should parse a block with no content" do
      parser.parse("{% block foo %}{% endblock %}").should have_an_identical_syntax_tree_to "block/empty.yml"
   end
end