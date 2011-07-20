require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'boolean parsing' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse an equivalency expression" do
      parser.parse("{{ foo == 1 }}").should have_an_identical_syntax_tree_to "boolean_equivalency.parse.yml"
   end

   it "should parse an inequivalency expression" do
      parser.parse("{{ foo != 1 }}").should have_an_identical_syntax_tree_to "boolean_inequivalency.parse.yml"
   end

   it "should parse a greater than inequivalency expression" do
      parser.parse("{{ foo > 1 }}").should have_an_identical_syntax_tree_to "boolean_greater.parse.yml"
   end

   it "should parse a less than inequivalency expression" do
      parser.parse("{{ foo < 1 }}").should have_an_identical_syntax_tree_to "boolean_less.parse.yml"
   end

   it "should parse a less than or equal to inequivalency expression" do
      parser.parse("{{ foo <= 1 }}").should have_an_identical_syntax_tree_to "boolean_less_than_or_equal_to.parse.yml"
   end

   it "should parse a greater than or equal to inequivalency expression" do
      parser.parse("{{ foo >= 1 }}").should have_an_identical_syntax_tree_to "boolean_greater_than_or_equal_to.parse.yml"
   end
end