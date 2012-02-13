require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::GenericBlockNode do
  subject { Cadenza::GenericBlockNode }

  context "equivalence" do
    let(:filter) { Cadenza::VariableNode.new("filter") }
    let(:escape) { Cadenza::VariableNode.new("escape") }
    let(:text)   { Cadenza::TextNode.new("Lorem Ipsum") }

    it 'should equal a node with the same identifier, children and parameters' do
      node_a = Cadenza::GenericBlockNode.new(filter, [text], [escape])
      node_b = Cadenza::GenericBlockNode.new(filter, [text], [escape])

      node_a.should == node_b
    end

    it "should not equal a node with a different identifier" do
      node_a = Cadenza::GenericBlockNode.new(escape, [text], [])
      node_b = Cadenza::GenericBlockNode.new(filter, [text], [])

      node_a.should_not == node_b
    end

    it "should not equal a node with different children" do
      text_b = Cadenza::TextNode.new("foo bar")

      node_a = Cadenza::GenericBlockNode.new(filter, [text], [escape])
      node_b = Cadenza::GenericBlockNode.new(filter, [text_b], [escape])

      node_a.should_not == node_b
    end

    it "should not equal a node with different parameters" do
      upcase = Cadenza::VariableNode.new("upcase")

      node_a = Cadenza::GenericBlockNode.new(filter, [text], [escape])
      node_b = Cadenza::GenericBlockNode.new(filter, [text], [upcase])

      node_a.should_not == node_b
    end
  end
end