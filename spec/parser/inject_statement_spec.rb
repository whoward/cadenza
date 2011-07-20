require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'inject statements' do
  let(:parser) { Cadenza::Parser.new }
  
  it "should parse an inject statement" do
    parser.parse('{{somevar}}').should have_an_identical_syntax_tree_to "inject.parse.yml"
  end
  
  it "should parse an inject statement with one filter" do
    parser.parse('{{ name | trim }}').should have_an_identical_syntax_tree_to "inject-one-filter.parse.yml"
  end

  it "should parse an inject statement with multiple filters" do
    parser.parse("{{ name | trim | upcase }}").should have_an_identical_syntax_tree_to "inject-multiple-filters.parse.yml"
  end

  it "should parse an inject statement with filters that have a parameter" do
    parser.parse("{{ name | cut: 5 }}").should have_an_identical_syntax_tree_to "inject-one-filter-with-params.parse.yml"
  end

  it "should parse an inject statement with filters which have multiple parameters" do
    parser.parse("{{ name | somefilter: 'foo', 3.14159 }}").should have_an_identical_syntax_tree_to "inject-one-filter-with-multiple-params.parse.yml"
  end

  it "should parse a multiple filter inject statement with multiple parameters" do
    parser.parse("{{ name | trim | somefilter: 'foo', 3.14159 }}").should have_an_identical_syntax_tree_to "inject-multiple-filter-multiple-params.parse.yml"
  end
end
