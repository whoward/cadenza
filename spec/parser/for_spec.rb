require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'for statements' do

   it "should parse a for statement" do
      expect_parsing("{% for foo in bar %}baz{% endfor %}").to equal_syntax_tree "for/basic.yml"
   end

   it "should parse a for statement with no content" do
      expect_parsing("{% for foo in bar %}{% endfor %}").to equal_syntax_tree "for/empty.yml"
   end
end