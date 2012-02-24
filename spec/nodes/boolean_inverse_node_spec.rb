require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::BooleanInverseNode do
  context "equivalence" do
    it "should equal a node with the same expression" do
      node_a = Cadenza::BooleanInverseNode.new(Cadenza::VariableNode.new('x'))
      node_b = Cadenza::BooleanInverseNode.new(Cadenza::VariableNode.new('x'))

      node_a.should == node_b
    end

    it "should not equal a node with  different expression" do
      node_a = Cadenza::BooleanInverseNode.new(Cadenza::VariableNode.new("x"))
      node_b = Cadenza::BooleanInverseNode.new(Cadenza::VariableNode.new("y"))

      node_a.should_not == node_b
    end
  end

  context "#eval" do
    it "should return the opposite of the result of evaluating the expression" do
      context = Cadenza::Context.new :number => 3

      number = Cadenza::VariableNode.new("number")
      three = Cadenza::ConstantNode.new(3)

      true_condition = Cadenza::OperationNode.new(number, "==", three)
      false_condition = Cadenza::OperationNode.new(number, "!=", three)

      Cadenza::BooleanInverseNode.new(true_condition).eval(context).should be_false
      Cadenza::BooleanInverseNode.new(false_condition).eval(context).should be_true
    end
  end
end