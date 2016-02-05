require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::BlockNode do
  it 'should be equivalent to a block with the same name and children' do
    text = Cadenza::TextNode.new('bar')

    block_a = Cadenza::BlockNode.new('foo', [text])
    block_b = Cadenza::BlockNode.new('foo', [text])

    expect(block_a).to eq(block_b)
  end

  it 'should not be equivalent to a block with a different name' do
    text = Cadenza::TextNode.new('bar')

    block_a = Cadenza::BlockNode.new('foo', [text])
    block_b = Cadenza::BlockNode.new('bar', [text])

    expect(block_a).not_to eq(block_b)
  end

  it 'should not be equivalent to a block with different children' do
    text_a = Cadenza::TextNode.new('bar')
    text_b = Cadenza::TextNode.new('baz')

    block_a = Cadenza::BlockNode.new('foo', [text_a])
    block_b = Cadenza::BlockNode.new('foo', [text_b])

    expect(block_a).not_to eq(block_b)
  end

  it "should return a list of its children's unique implied globals" do
    inject_a = Cadenza::VariableNode.new('a')
    inject_b = Cadenza::VariableNode.new('b')

    block_a = Cadenza::BlockNode.new('foo', [inject_a, inject_b])
    block_b = Cadenza::BlockNode.new('foo', [inject_a, inject_a])

    expect(block_a.implied_globals).to eq(%w(a b))
    expect(block_b.implied_globals).to eq(%w(a))
  end
end
