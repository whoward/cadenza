require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, "arithmetic parsing" do
  let(:parser) { Cadenza::Parser.new }

  it "should parse a additive expression" do
    parser.parse("{{ x + 1 }}").should have_an_identical_syntax_tree_to "additive_expression.parse.yml"
  end

  it "should parse multiple additive terms, ordered for evaluation left to right" do
    parser.parse("{{ a + b + c }}").should have_an_identical_syntax_tree_to "multiple_additive_expression.parse.yml"
  end

  it "should parse a subtractive expression" do
    parser.parse("{{ a - b }}").should have_an_identical_syntax_tree_to "subtractive_expression.parse.yml"
  end

  it "should parse a multiplicative expression" do
    parser.parse("{{ a * b }}").should have_an_identical_syntax_tree_to "multiplicative_expression.parse.yml"
  end

  it 'should parse a division expression' do
    parser.parse("{{ a / b }}").should have_an_identical_syntax_tree_to "division_expression.parse.yml"
  end

  it 'should parse a complex arithmetic expression using proper order of operations without brackets' do
    parser.parse("{{ a + b * c }}").should have_an_identical_syntax_tree_to "complex_expression.parse.yml"
  end

  it 'should give precedence to brackets' do
    parser.parse("{{ (a + b) * c }}").should have_an_identical_syntax_tree_to "brackets_expression.parse.yml"
  end

end