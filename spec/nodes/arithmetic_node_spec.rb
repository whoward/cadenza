require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::ArithmeticNode do

  it "should equal a node with the same operands and operator" do
    variable = Cadenza::VariableNode.new("x")
    constant = Cadenza::ConstantNode.new(1)

    Cadenza::ArithmeticNode.new(variable, "+", constant).should == Cadenza::ArithmeticNode.new(variable, "+", constant)
  end

  it "should not equal a node with a different operator" do
    variable = Cadenza::VariableNode.new("x")
    constant = Cadenza::ConstantNode.new(1)

    Cadenza::ArithmeticNode.new(variable, "+", constant).should_not == Cadenza::ArithmeticNode.new(variable, "-", constant)
  end

  it "should not equal a node with a different left operand" do
    variable_a = Cadenza::VariableNode.new("x")
    variable_b = Cadenza::VariableNode.new("y")
    constant = Cadenza::ConstantNode.new(1)

    Cadenza::ArithmeticNode.new(variable_a, "+", constant).should_not == Cadenza::ArithmeticNode.new(variable_b, "+", constant)
  end

  it "should not equal a node with a different right operand" do
    variable = Cadenza::VariableNode.new("x")
    constant_a = Cadenza::ConstantNode.new(1)
    constant_b = Cadenza::ConstantNode.new(9)

    Cadenza::ArithmeticNode.new(variable, "+", constant_a).should_not == Cadenza::ArithmeticNode.new(variable, "+", constant_b)
  end

  it "should return the union of it's left and right nodes for implied globals" do
    variable_a = Cadenza::VariableNode.new("a")
    variable_b = Cadenza::VariableNode.new("b")

    arithmetic_a = Cadenza::ArithmeticNode.new(variable_a, "+", variable_b)
    arithmetic_b = Cadenza::ArithmeticNode.new(variable_a, "+", variable_a)

    arithmetic_a.implied_globals.should == %w(a b)
    arithmetic_b.implied_globals.should == %w(a)
  end

  it "should eval to the arithmetic value determined by the operator and operands" do
    constant_a = Cadenza::ConstantNode.new(10)
    constant_b = Cadenza::ConstantNode.new(2)

    context = Cadenza::Context.new

    Cadenza::ArithmeticNode.new(constant_a, "+", constant_b).eval(context).should == 12
    Cadenza::ArithmeticNode.new(constant_a, "-", constant_b).eval(context).should == 8
    Cadenza::ArithmeticNode.new(constant_a, "*", constant_b).eval(context).should == 20
    Cadenza::ArithmeticNode.new(constant_a, "/", constant_b).eval(context).should == 5
  end

end