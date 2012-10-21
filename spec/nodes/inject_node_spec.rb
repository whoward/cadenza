require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::InjectNode do

  context "equivalence" do
    it "doesn't equal a node with different values" do
      constant_a = Cadenza::ConstantNode.new(10)
      constant_b = Cadenza::ConstantNode.new(20)

      inject_a = Cadenza::InjectNode.new(constant_a)
      inject_b = Cadenza::InjectNode.new(constant_b)

      inject_a.should_not == inject_b
    end

    it "equals a node with the same value" do 
      inject_a = Cadenza::InjectNode.new(Cadenza::ConstantNode.new(10))
      inject_b = Cadenza::InjectNode.new(Cadenza::ConstantNode.new(10))

      inject_a.should == inject_b
    end
  end

  context "implied globals" do
    it "returns the implied globals of the injected value" do
      inject = Cadenza::InjectNode.new(Cadenza::VariableNode.new("x"))

      inject.implied_globals.should == %w(x)
    end
  end

  context "evaluation" do
    let(:context) { Cadenza::Context.new(:pi => 3.14159) }

    it "evaluates to the value of it's value" do
      inject = Cadenza::InjectNode.new(Cadenza::VariableNode.new("pi"))
      inject.evaluate(context).should == 3.14159
    end
  end
end