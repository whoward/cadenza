require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::ConstantNode do
  it 'should equal a node with the same value' do
    expect(Cadenza::ConstantNode.new(10)).to eq(Cadenza::ConstantNode.new(10))
  end

  it 'should not equal a node with a different value' do
    expect(Cadenza::ConstantNode.new(20)).not_to eq(Cadenza::ConstantNode.new(10))
  end

  it "should evaluate to it's constant value" do
    expect(Cadenza::ConstantNode.new(3.14159).eval(Cadenza::Context.new)).to eq(3.14159)
  end
end
