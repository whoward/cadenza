require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::InjectNode do

  it "should not equal a node with different values" do
    constant_a = Cadenza::ConstantNode.new(10)
    constant_b = Cadenza::ConstantNode.new(20)

    inject_a = Cadenza::InjectNode.new(constant_a)
    inject_b = Cadenza::InjectNode.new(constant_b)

    inject_a.should_not == inject_b
  end

  it "should equal a node with the same value" do 
    inject_a = Cadenza::InjectNode.new(Cadenza::ConstantNode.new(10))
    inject_b = Cadenza::InjectNode.new(Cadenza::ConstantNode.new(10))

    inject_a.should == inject_b
  end

  it "should not equal a node with different filters" do
    inject_a = Cadenza::InjectNode.new(Cadenza::ConstantNode.new(10), [Cadenza::FilterNode.new("trim")])
    inject_b = Cadenza::InjectNode.new(Cadenza::ConstantNode.new(10), [])

    inject_a.should_not == inject_b
  end

  it "should accept an optional filter list in it's constructor" do
    constant = Cadenza::VariableNode.new("name")
    filter = Cadenza::FilterNode.new("trim")

    inject = Cadenza::InjectNode.new(constant, [filter])

    inject.filters.should == [filter]
  end

  it "should return the value's implied globals unioned with the filters's implied globals (unique)" do
    value = Cadenza::VariableNode.new("myvar")

    filter_a = Cadenza::FilterNode.new("foo", [value])
    filter_b = Cadenza::FilterNode.new("bar", [Cadenza::ConstantNode.new(3.14)])
    filter_c = Cadenza::FilterNode.new("baz", [Cadenza::VariableNode.new("x"), Cadenza::VariableNode.new("y")])
    filter_d = Cadenza::FilterNode.new("one", [Cadenza::VariableNode.new("y")])

    inject = Cadenza::InjectNode.new(value, [filter_a, filter_b, filter_c, filter_d])

    inject.implied_globals.should == %w(myvar x y)
  end

  it "should evaluate to the value's evaluation if there are no filters" do
    inject = Cadenza::InjectNode.new(Cadenza::VariableNode.new("pi"))
    context = Cadenza::Context.new(:pi => 3.14159)

    inject.evaluate(context).should == 3.14159
  end

  it "should evaluate to the value's evaluation passed through each chained filter" do
    pi = Cadenza::VariableNode.new("pi")
    
    floor = Cadenza::FilterNode.new("floor")
    add_one = Cadenza::FilterNode.new("add", [Cadenza::ConstantNode.new(1)])

    inject = Cadenza::InjectNode.new(pi, [floor, add_one])

    context = Cadenza::Context.new(:pi => 3.14159)

    context.define_filter(:floor) {|value|        value.floor    }
    context.define_filter(:add)   {|value,amount| value + amount }

    inject.evaluate(context).should == 4
  end

end