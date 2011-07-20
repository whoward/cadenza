require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'generic statements parsing' do
  let(:parser) { Cadenza::Parser.new }

  it "should parse a generic statement without parameters" do
    parser.parse("{% server_environment %}").should have_an_identical_syntax_tree_to "generic_statement_without_parameters.parse.yml"
  end

  it "should parse a generic statement with parameters" do
    parser.parse("{% javascript_include_tag 'jquery-1.6.0.js' %}").should have_an_identical_syntax_tree_to "generic_statement_with_parameters.parse.yml"
  end
end
