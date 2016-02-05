require 'spec_helper'

describe Cadenza::BlockHierarchy do
  subject { Cadenza::BlockHierarchy }

  let(:hierarchy) { subject.new }

  let(:foo_block_a) { Cadenza::BlockNode.new('foo') }

  let(:foo_block_b) { Cadenza::BlockNode.new('foo', [Cadenza::TextNode.new('text')]) }

  context '#initialize' do
    it 'begins with a empty block hierarchy' do
      expect(subject.new['foo']).to eq([])
    end

    it 'allows passing an optional hash to become the initial data' do
      expect(subject.new(foo: foo_block_a)['foo']).to eq([foo_block_a])
    end
  end

  context '#[]' do
    it 'returns an empty array for an undefined block' do
      expect(hierarchy['foo']).to eq([])
    end

    it 'returns the whole chain from lowest to highest ancestor' do
      hierarchy << foo_block_a
      hierarchy << foo_block_b
      hierarchy['foo'] == [foo_block_a, foo_block_b]
    end
  end

  context '#push' do
    it 'assigns the block to the end of the hierarchy chain' do
      expect(hierarchy['foo']).to eq([])
      hierarchy << foo_block_a
      expect(hierarchy['foo']).to eq([foo_block_a])
    end
  end

  context '#merge' do
    it 'pushes each block in the passed hash onto the end of the chain' do
      hierarchy << foo_block_a
      hierarchy.merge(foo: foo_block_b)
      expect(hierarchy['foo']).to eq([foo_block_a, foo_block_b])
    end
  end
end
