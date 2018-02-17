# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::DocumentNode do
  before do
    @document_a = Cadenza::DocumentNode.new
    @document_b = Cadenza::DocumentNode.new
  end

  it 'should be equal to another empty document' do
    expect(@document_a).to eq(@document_b)
  end

  it 'should equal a document with the same child elements' do
    @document_a.children.push(Cadenza::ConstantNode.new(10))
    @document_b.children.push(Cadenza::ConstantNode.new(10))

    expect(@document_a).to eq(@document_b)
  end

  it 'should not equal a document with different child elements' do
    @document_a.children.push(Cadenza::ConstantNode.new(10))
    @document_b.children.push(Cadenza::ConstantNode.new(20))

    expect(@document_a).not_to eq(@document_b)
  end

  it 'should not equal a document with different extends values' do
    @document_a.extends = 'foo'
    @document_b.extends = 'bar'

    expect(@document_a).not_to eq(@document_b)
  end

  it 'should not equal a document with different blocks' do
    @document_a.blocks = [Cadenza::BlockNode.new('foo', [])]
    @document_b.blocks = [Cadenza::BlockNode.new('bar', [])]

    expect(@document_a).not_to eq(@document_b)
  end
end
