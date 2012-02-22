require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::InjectNode do

  context "equivalence" do
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

    it "should not equal a node with different parameters" do
      inject_a = Cadenza::InjectNode.new(Cadenza::VariableNode.new('load'), [], [Cadenza::ConstantNode.new("mytemplate")])
      inject_b = Cadenza::InjectNode.new(Cadenza::VariableNode.new('load'), [], [Cadenza::ConstantNode.new("foo")])

      inject_a.should_not == inject_b
    end
  end

  context "constructor" do
    it "should accept an optional filter list in it's constructor" do
      constant = Cadenza::VariableNode.new("name")
      filter = Cadenza::FilterNode.new("trim")

      inject = Cadenza::InjectNode.new(constant, [filter])

      inject.filters.should == [filter]
    end

    it "should accept an optional list of parameters in it's constructor" do
      constant = Cadenza::VariableNode.new("load")
      param = Cadenza::ConstantNode.new("mytemplate")

      inject = Cadenza::InjectNode.new(constant, [], [param])

      inject.parameters.should == [param]
    end
  end

  context "implied globals" do
    it "should return the value's implied globals unioned with the filters's implied globals (unique)" do
      value = Cadenza::VariableNode.new("myvar")

      filter_a = Cadenza::FilterNode.new("foo", [value])
      filter_b = Cadenza::FilterNode.new("bar", [Cadenza::ConstantNode.new(3.14)])
      filter_c = Cadenza::FilterNode.new("baz", [Cadenza::VariableNode.new("x"), Cadenza::VariableNode.new("y")])
      filter_d = Cadenza::FilterNode.new("one", [Cadenza::VariableNode.new("y")])

      inject = Cadenza::InjectNode.new(value, [filter_a, filter_b, filter_c, filter_d])

      inject.implied_globals.should == %w(myvar x y)
    end
  end

  context "evaluation" do
    let(:context)      { Cadenza::Context.new(:pi => 3.14159) }
    let(:pi_node)      { Cadenza::VariableNode.new("pi") }
    let(:ctx_node)     { Cadenza::VariableNode.new("ctx") }
    let(:floor_node)   { Cadenza::FilterNode.new("floor") }
    let(:add_one_node) { Cadenza::FilterNode.new("add", [Cadenza::ConstantNode.new(1)]) }

    before do
      context.define_functional_variable(:ctx) {|context| context.inspect } # output's the inspected context
      context.define_functional_variable(:load) {|context, template| template == "foo" ? "bar" : "baz" } # fake load method

      context.define_filter(:floor, &:floor)
      context.define_filter(:upper, &:upcase)
      context.define_filter(:add) {|value,amount| value + amount }
    end

    it "should evaluate to the value's evaluation if there are no filters" do
      inject = Cadenza::InjectNode.new(pi_node)
      inject.evaluate(context).should == 3.14159
    end

    it "should evaluate to the value's evaluation passed through each chained filter" do
      inject = Cadenza::InjectNode.new(pi_node, [floor_node, add_one_node])
      inject.evaluate(context).should == 4
    end

    it "should evaluate a functional variables's value" do
      Cadenza::InjectNode.new(ctx_node).evaluate(context).should == context.inspect
    end

    it "should evaluate a functional variable's value given parameters" do
      load = Cadenza::VariableNode.new("load")

      template_a = Cadenza::ConstantNode.new("foo")
      template_b = Cadenza::ConstantNode.new("abc")

      Cadenza::InjectNode.new(load, [], [template_a]).evaluate(context).should == "bar"
      Cadenza::InjectNode.new(load, [], [template_b]).evaluate(context).should == "baz"
    end

    it "should evaluate a functional variable's value given parameters and filters" do
      load = Cadenza::VariableNode.new("load")
      upper = Cadenza::FilterNode.new("upper")
      template = Cadenza::ConstantNode.new("foo")

      Cadenza::InjectNode.new(load, [upper], [template]).evaluate(context).should == "BAR"
    end
  end
end