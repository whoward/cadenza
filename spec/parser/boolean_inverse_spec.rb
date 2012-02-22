require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'boolean inverse parsing' do
   let(:parser) { Cadenza::Parser.new }

   it "should parse an inverse" do
      parser.parse("{{ not x }}").should have_an_identical_syntax_tree_to "inverse/not_x.yml"
   end
end