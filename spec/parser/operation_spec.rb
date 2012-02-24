require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'operation parsing' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse an equivalency expression" do
      parser.parse("{{ foo == 1 }}").should have_an_identical_syntax_tree_to "operation/equivalency.yml"
   end

   it "should parse an inequivalency expression" do
      parser.parse("{{ foo != 1 }}").should have_an_identical_syntax_tree_to "operation/inequivalency.yml"
   end

   it "should parse a greater than inequivalency expression" do
      parser.parse("{{ foo > 1 }}").should have_an_identical_syntax_tree_to "operation/greater.yml"
   end

   it "should parse a less than inequivalency expression" do
      parser.parse("{{ foo < 1 }}").should have_an_identical_syntax_tree_to "operation/less.yml"
   end

   it "should parse a less than or equal to inequivalency expression" do
      parser.parse("{{ foo <= 1 }}").should have_an_identical_syntax_tree_to "operation/less_than_or_equal_to.yml"
   end

   it "should parse a greater than or equal to inequivalency expression" do
      parser.parse("{{ foo >= 1 }}").should have_an_identical_syntax_tree_to "operation/greater_than_or_equal_to.yml"
   end

   it "should parse an 'and' conjunction" do
      parser.parse("{{ foo == 1 and bar > 3 }}").should have_an_identical_syntax_tree_to "operation/and.yml"
   end

   it "should parse an 'or' conjunction" do
      parser.parse("{{ foo == 1 or bar > 3 }}").should have_an_identical_syntax_tree_to "operation/or.yml"
   end


   it "should parse a additive expression" do
      parser.parse("{{ x + 1 }}").should have_an_identical_syntax_tree_to "operation/additive.yml"
   end

   it "should parse multiple additive terms, ordered for evaluation left to right" do
      parser.parse("{{ a + b + c }}").should have_an_identical_syntax_tree_to "operation/multiple_additive.yml"
   end

   it "should parse a subtractive expression" do
      parser.parse("{{ a - b }}").should have_an_identical_syntax_tree_to "operation/subtractive.yml"
   end

   it "should parse a multiplicative expression" do
      parser.parse("{{ a * b }}").should have_an_identical_syntax_tree_to "operation/multiplicative.yml"
   end

   it 'should parse a division expression' do
      parser.parse("{{ a / b }}").should have_an_identical_syntax_tree_to "operation/division.yml"
   end

   it 'should parse a complex boolean expression using proper order of operations without brackets' do
      parser.parse("{{ a + b * c }}").should have_an_identical_syntax_tree_to "operation/complex.yml"
   end

   it 'should give precedence to brackets' do
      parser.parse("{{ (a + b) * c }}").should have_an_identical_syntax_tree_to "operation/brackets.yml"
   end
end