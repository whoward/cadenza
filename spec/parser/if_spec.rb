require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'if statements' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse an if statement" do
      parser.parse("{% if foo %}bar{% endif %}").should have_an_identical_syntax_tree_to "if.parse.yml"
   end

   it "shoudl parse an if/else statement" do
      parser.parse("{% if foo %}bar{% else %}baz{% endif %}").should have_an_identical_syntax_tree_to "if_else.parse.yml"
   end
end