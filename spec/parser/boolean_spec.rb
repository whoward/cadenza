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


   it "should parse a additive expression" do
      parser.parse("{{ x + 1 }}").should have_an_identical_syntax_tree_to "boolean/additive.yml"
   end

   it "should parse multiple additive terms, ordered for evaluation left to right" do
      parser.parse("{{ a + b + c }}").should have_an_identical_syntax_tree_to "boolean/multiple_additive.yml"
   end

   it "should parse a subtractive expression" do
      parser.parse("{{ a - b }}").should have_an_identical_syntax_tree_to "boolean/subtractive.yml"
   end

   it "should parse a multiplicative expression" do
      parser.parse("{{ a * b }}").should have_an_identical_syntax_tree_to "boolean/multiplicative.yml"
   end

   it 'should parse a division expression' do
      parser.parse("{{ a / b }}").should have_an_identical_syntax_tree_to "boolean/division.yml"
   end

   it 'should parse a complex boolean expression using proper order of operations without brackets' do
      parser.parse("{{ a + b * c }}").should have_an_identical_syntax_tree_to "boolean/complex.yml"
   end

   it 'should give precedence to brackets' do
      parser.parse("{{ (a + b) * c }}").should have_an_identical_syntax_tree_to "boolean/brackets.yml"
   end
end