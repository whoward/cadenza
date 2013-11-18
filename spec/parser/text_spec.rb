require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'text nodes' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse text nodes" do
      expect_parsing("abc{{def}}ghi").to equal_syntax_tree "text/basic.yml"
   end
end