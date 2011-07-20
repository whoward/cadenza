require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'constant nodes' do
  let(:parser) { Cadenza::Parser.new }

  it "should parse a integer token into a constant node" do
    parser.parse("{{ 42 }}").should have_an_identical_syntax_tree_to "integer.parse.yml"
  end

  it "should parse a real token into a constant node" do
    parser.parse("{{ 3.14 }}").should have_an_identical_syntax_tree_to "real.parse.yml"
  end

  it "should parse a string token into a constant node" do
    parser.parse("{{ 'Foo' }}").should have_an_identical_syntax_tree_to "string.parse.yml"
  end

end