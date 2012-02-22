require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'for statements' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse a for statement" do
      parser.parse("{% for foo in bar %}baz{% endfor %}").should have_an_identical_syntax_tree_to "for.parse.yml"
   end

   it "should parse a for statement with no content" do
      parser.parse("{% for foo in bar %}{% endfor %}").should have_an_identical_syntax_tree_to "empty_for.parse.yml"
   end
end