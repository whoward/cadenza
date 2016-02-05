require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::TextNode do
  it 'should be equal to another node with the same content' do
    text_a = Cadenza::TextNode.new('foo')
    text_b = Cadenza::TextNode.new('foo')

    text_a.should == text_b
  end

  it 'should not equal another node with different content' do
    text_a = Cadenza::TextNode.new('foo')
    text_b = Cadenza::TextNode.new('bar')

    text_a.should_not == text_b
  end

  it 'should return an empty list for implied globals' do
    Cadenza::TextNode.new('foo').implied_globals.should == []
  end
end
