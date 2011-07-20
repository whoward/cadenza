require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::GenericStatementNode do

  it "should equal a generic statement with the same name and parameters" do
    param_a = Cadenza::ConstantNode.new(3.14)
    param_b = Cadenza::VariableNode.new("x")

    statement_a = Cadenza::GenericStatementNode.new("foo", [param_a, param_b])
    statement_b = Cadenza::GenericStatementNode.new("foo", [param_a, param_b])

    statement_a.should == statement_b
  end

  it "should not equal a generic statement with a different name" do
    param_a = Cadenza::ConstantNode.new(3.14)
    param_b = Cadenza::VariableNode.new("x")

    statement_a = Cadenza::GenericStatementNode.new("foo", [param_a, param_b])
    statement_b = Cadenza::GenericStatementNode.new("bar", [param_a, param_b])

    statement_a.should_not == statement_b
  end

  it "should not equal a generic statement with different parameters" do
    param_a = Cadenza::ConstantNode.new(3.14)
    param_b = Cadenza::VariableNode.new("x")

    statement_a = Cadenza::GenericStatementNode.new("foo", [param_a, param_b])
    statement_b = Cadenza::GenericStatementNode.new("foo", [param_a])

    statement_a.should_not == statement_b
  end

  it "should assign an empty array to parameters by default" do
    statement = Cadenza::GenericStatementNode.new("foo")

    statement.parameters.should == []
  end

  it "should return a unique list of it's parameter's implied globals" do
    param_a = Cadenza::VariableNode.new("bar")
    param_b = Cadenza::VariableNode.new("baz")

    statement_a = Cadenza::GenericStatementNode.new("foo", [param_a, param_b])
    statement_b = Cadenza::GenericStatementNode.new("foo", [param_a, param_a])

    statement_a.implied_globals.should == %w(bar baz)
    statement_b.implied_globals.should == %w(bar)
  end

end