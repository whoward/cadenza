require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::ConstantNode do
  it 'should equal a node with the same value' do
    Cadenza::ConstantNode.new(10).should == Cadenza::ConstantNode.new(10)
  end

  it 'should not equal a node with a different value' do
    Cadenza::ConstantNode.new(20).should_not == Cadenza::ConstantNode.new(10)
  end

  it 'should return an empty array for implied globals' do
    Cadenza::ConstantNode.new(20).implied_globals.should == []
  end

  it "should evaluate to it's constant value" do
    Cadenza::ConstantNode.new(3.14159).eval(Cadenza::Context.new).should == 3.14159
  end
end
