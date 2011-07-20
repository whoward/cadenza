require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'extends statement' do
   let(:parser) { Cadenza::Parser.new }

   it "should assign the string value to the document" do
      parser.parse("{% extends 'foo' %}").should have_an_identical_syntax_tree_to "document_extends_string.parse.yml"
   end

   it "should assign the variable value to the document" do
      parser.parse("{% extends somefile %}").should have_an_identical_syntax_tree_to "document_extends_variable.parse.yml"
   end

end