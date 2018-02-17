# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::TextNode do
  it 'should be equal to another node with the same content' do
    text_a = Cadenza::TextNode.new('foo')
    text_b = Cadenza::TextNode.new('foo')

    expect(text_a).to eq(text_b)
  end

  it 'should not equal another node with different content' do
    text_a = Cadenza::TextNode.new('foo')
    text_b = Cadenza::TextNode.new('bar')

    expect(text_a).not_to eq(text_b)
  end
end
