require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'if statements' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse an if statement" do
      parser.parse("{% if foo %}bar{% endif %}").should have_an_identical_syntax_tree_to "if/basic.yml"
   end

   it "should parse an if/else statement" do
      parser.parse("{% if foo %}bar{% else %}baz{% endif %}").should have_an_identical_syntax_tree_to "if/else.yml"
   end

   it "should parse an if statement with no true content" do
      parser.parse("{% if foo %}{% endif %}").should have_an_identical_syntax_tree_to "if/empty.yml"
   end

   it "should parse an if statement with no true content and an else block" do
      parser.parse("{% if foo %}{% else %}bar{% endif %}").should have_an_identical_syntax_tree_to "if/empty_true.yml"
   end

   it "should parse an if statement with true content but no false content" do
      parser.parse("{% if foo %}bar{% else %}{% endif %}").should have_an_identical_syntax_tree_to "if/empty_false.yml"
   end
end