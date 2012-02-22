require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'variable nodes' do
  let(:parser) { Cadenza::Parser.new }

  it "should parse a identifier token into a variable node" do
    parser.parse("{{ foo }}").should have_an_identical_syntax_tree_to "variable/basic.yml"
  end

end