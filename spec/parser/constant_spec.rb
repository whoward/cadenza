require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'constant nodes' do

  it "should parse a integer token into a constant node" do
    expect_parsing("{{ 42 }}").to equal_syntax_tree "constant/integer.yml"
  end

  it "should parse a real token into a constant node" do
    expect_parsing("{{ 3.14 }}").to equal_syntax_tree "constant/real.yml"
  end

  it "should parse a string token into a constant node" do
    expect_parsing("{{ 'Foo' }}").to equal_syntax_tree "constant/string.yml"
  end

end