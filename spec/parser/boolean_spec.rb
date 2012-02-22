require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'boolean parsing' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse an equivalency expression" do
      parser.parse("{{ foo == 1 }}").should have_an_identical_syntax_tree_to "boolean/equivalency.yml"
   end

   it "should parse an inequivalency expression" do
      parser.parse("{{ foo != 1 }}").should have_an_identical_syntax_tree_to "boolean/inequivalency.yml"
   end

   it "should parse a greater than inequivalency expression" do
      parser.parse("{{ foo > 1 }}").should have_an_identical_syntax_tree_to "boolean/greater.yml"
   end

   it "should parse a less than inequivalency expression" do
      parser.parse("{{ foo < 1 }}").should have_an_identical_syntax_tree_to "boolean/less.yml"
   end

   it "should parse a less than or equal to inequivalency expression" do
      parser.parse("{{ foo <= 1 }}").should have_an_identical_syntax_tree_to "boolean/less_than_or_equal_to.yml"
   end

   it "should parse a greater than or equal to inequivalency expression" do
      parser.parse("{{ foo >= 1 }}").should have_an_identical_syntax_tree_to "boolean/greater_than_or_equal_to.yml"
   end

   it "should parse an 'and' conjunction" do
      parser.parse("{{ foo == 1 and bar > 3 }}").should have_an_identical_syntax_tree_to "boolean/and.yml"
   end

   it "should parse an 'or' conjunction" do
      parser.parse("{{ foo == 1 or bar > 3 }}").should have_an_identical_syntax_tree_to "boolean/or.yml"
   end
end