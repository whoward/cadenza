require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'operation parsing' do
  it 'should parse an equivalency expression' do
    expect_parsing('{{ foo == 1 }}').to equal_syntax_tree 'operation/equivalency.yml'
  end

  it 'should parse an inequivalency expression' do
    expect_parsing('{{ foo != 1 }}').to equal_syntax_tree 'operation/inequivalency.yml'
  end

  it 'should parse a greater than inequivalency expression' do
    expect_parsing('{{ foo > 1 }}').to equal_syntax_tree 'operation/greater.yml'
  end

  it 'should parse a less than inequivalency expression' do
    expect_parsing('{{ foo < 1 }}').to equal_syntax_tree 'operation/less.yml'
  end

  it 'should parse a less than or equal to inequivalency expression' do
    expect_parsing('{{ foo <= 1 }}').to equal_syntax_tree 'operation/less_than_or_equal_to.yml'
  end

  it 'should parse a greater than or equal to inequivalency expression' do
    expect_parsing('{{ foo >= 1 }}').to equal_syntax_tree 'operation/greater_than_or_equal_to.yml'
  end

  it "should parse an 'and' conjunction" do
    expect_parsing('{{ foo == 1 and bar > 3 }}').to equal_syntax_tree 'operation/and.yml'
  end

  it "should parse an 'or' conjunction" do
    expect_parsing('{{ foo == 1 or bar > 3 }}').to equal_syntax_tree 'operation/or.yml'
  end

  it 'should parse a additive expression' do
    expect_parsing('{{ x + 1 }}').to equal_syntax_tree 'operation/additive.yml'
  end

  it 'should parse multiple additive terms, ordered for evaluation left to right' do
    expect_parsing('{{ a + b + c }}').to equal_syntax_tree 'operation/multiple_additive.yml'
  end

  it 'should parse a subtractive expression' do
    expect_parsing('{{ a - b }}').to equal_syntax_tree 'operation/subtractive.yml'
  end

  it 'should parse a multiplicative expression' do
    expect_parsing('{{ a * b }}').to equal_syntax_tree 'operation/multiplicative.yml'
  end

  it 'should parse a division expression' do
    expect_parsing('{{ a / b }}').to equal_syntax_tree 'operation/division.yml'
  end

  it 'should parse a complex boolean expression using proper order of operations without brackets' do
    expect_parsing('{{ a + b * c }}').to equal_syntax_tree 'operation/complex.yml'
  end

  it 'should give precedence to brackets' do
    expect_parsing('{{ (a + b) * c }}').to equal_syntax_tree 'operation/brackets.yml'
  end
end
