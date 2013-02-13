require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::FilterNode do
  it "should take an identifier" do
    filter = Cadenza::FilterNode.new("trim")

    filter.identifier.should == "trim"
  end

  it "should be equal to another filter with the same name" do
    filter_a = Cadenza::FilterNode.new("trim")
    filter_b = Cadenza::FilterNode.new("trim")

    filter_a.should == filter_b
  end

  it "should not equal another node with a different name" do
    filter_a = Cadenza::FilterNode.new("trim")
    filter_b = Cadenza::FilterNode.new("cut")

    filter_a.should_not == filter_b
  end

  it "should equal a node with the same parameters" do
    filter_a = Cadenza::FilterNode.new("trim", [Cadenza::ConstantNode.new(10)])
    filter_b = Cadenza::FilterNode.new("trim", [Cadenza::ConstantNode.new(10)])

    filter_a.should == filter_b
  end

  it "should not equal a node with different parameters" do
    filter_a = Cadenza::FilterNode.new("trim", [Cadenza::ConstantNode.new(10)])
    filter_b = Cadenza::FilterNode.new("trim", [Cadenza::ConstantNode.new(30)])

    filter_a.should_not == filter_b    
  end

  it "should take a list of parameter nodes" do
    constant_a = Cadenza::ConstantNode.new(10)

    filter = Cadenza::FilterNode.new("cut", [constant_a])

    filter.identifier.should == "cut"
    filter.parameters.should == [constant_a]
  end

  it "should return a list of it's parameters implied globals (unique)" do
    constant = Cadenza::ConstantNode.new(10)
    variable = Cadenza::VariableNode.new("x")

    filter = Cadenza::FilterNode.new("cut", [constant, variable, variable])

    filter.implied_globals.should == %w(x)
  end

  it "should evaluate the filter on a value given a context" do
    klass = Class.new(Cadenza::Context)
    klass.define_filter(:floor) {|value, params| value.floor }

    context = klass.new

    filter = Cadenza::FilterNode.new("floor")

    filter.evaluate(context, 3.14159).should == 3
  end

  it "should pass parameters to the filter function when evaluating" do
    klass = Class.new(Cadenza::Context)
    klass.define_filter(:add) {|value, params| value + params.first }
    
    context = klass.new

    filter = Cadenza::FilterNode.new("add", [Cadenza::ConstantNode.new(1)])

    filter.evaluate(context, 3.14159).should == 4.14159
  end
end