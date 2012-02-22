require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'unless statements' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse an unless statement" do
      parser.parse("{% unless foo %}bar{% endunless %}").should have_an_identical_syntax_tree_to "unless/basic.yml"
   end

   it "should parse an if/else statement" do
      parser.parse("{% unless foo %}bar{% else %}baz{% endunless %}").should have_an_identical_syntax_tree_to "unless/else.yml"
   end

   it "should parse an if statement with no true content" do
      parser.parse("{% unless foo %}{% endunless %}").should have_an_identical_syntax_tree_to "unless/empty.yml"
   end

   it "should parse an if statement with no true content and an else block" do
      parser.parse("{% unless foo %}{% else %}bar{% endunless %}").should have_an_identical_syntax_tree_to "unless/empty_true.yml"
   end

   it "should parse an if statement with true content but no false content" do
      parser.parse("{% unless foo %}bar{% else %}{% endunless %}").should have_an_identical_syntax_tree_to "unless/empty_false.yml"
   end
end