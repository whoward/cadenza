require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'render statements' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse a string render statement" do
      parser.parse("{% render 'foo' %}").should have_an_identical_syntax_tree_to "render_with_string.parse.yml"
   end

   it "should parse an identifier render statement" do
      parser.parse("{% render foo %}").should have_an_identical_syntax_tree_to "render_with_identifier.parse.yml"
   end

end