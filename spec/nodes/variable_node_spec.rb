require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::VariableNode do

   context "equivalence" do
      it "equals a node with the same name" do
         Cadenza::VariableNode.new("foo").should == Cadenza::VariableNode.new("foo")
      end

      it "doesn't equal a node with a different name" do
         Cadenza::VariableNode.new("foo").should_not == Cadenza::VariableNode.new("bar")
      end

      it "doesn't equal a node with different filters" do
         var_a = Cadenza::VariableNode.new("foo", [Cadenza::FilterNode.new("trim")])
         var_b = Cadenza::VariableNode.new("foo", [])

         var_a.should_not == var_b
      end

      it "doesn't equal a node with different parameters" do
         var_a = Cadenza::VariableNode.new('load', [], [Cadenza::ConstantNode.new("mytemplate")])
         var_b = Cadenza::VariableNode.new('load', [], [Cadenza::ConstantNode.new("foo")])

         var_a.should_not == var_b
      end
   end

   context "#implied_globals" do
      it "returns a list containing the identifier name" do
         Cadenza::VariableNode.new("foo").implied_globals.should == %w(foo)
      end

      it "returns the filters's implied globals as well" do
         filter_a = Cadenza::FilterNode.new("foo")
         filter_b = Cadenza::FilterNode.new("bar", [Cadenza::ConstantNode.new(3.14)])
         filter_c = Cadenza::FilterNode.new("baz", [Cadenza::VariableNode.new("x"), Cadenza::VariableNode.new("y")])
         filter_d = Cadenza::FilterNode.new("one", [Cadenza::VariableNode.new("y")])

         variable = Cadenza::VariableNode.new("myvar", [filter_a, filter_b, filter_c, filter_d])

         variable.implied_globals.should == %w(myvar x y)
      end

      it "returns the parameters' implied globals as well" do
         x = Cadenza::VariableNode.new("x")

         Cadenza::VariableNode.new("foo", [], [x, x]).implied_globals.should == %w(foo x)
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

      it "evaluates to the value looked up in the context" do
         Cadenza::VariableNode.new("pi").eval(context).should == 3.14159
      end

      it "evaluates to the value's evaluation passed through each chained filter" do
         Cadenza::VariableNode.new("pi", [floor_node, add_one_node]).eval(context).should == 4
      end

      it "evaluates a functional variables's value" do
         Cadenza::VariableNode.new("ctx").eval(context).should == context.inspect
      end
      
      it "evaluates a functional variable's value given parameters" do
         template_a = Cadenza::ConstantNode.new("foo")
         template_b = Cadenza::ConstantNode.new("abc")

         Cadenza::VariableNode.new("load", [], [template_a]).eval(context).should == "bar"
         Cadenza::VariableNode.new("load", [], [template_b]).eval(context).should == "baz"
      end

      it "evaluates a functional variable's value given parameters and filters" do
         upper = Cadenza::FilterNode.new("upper")
         template = Cadenza::ConstantNode.new("foo")

         Cadenza::VariableNode.new("load", [upper], [template]).eval(context).should == "BAR"
      end
   end

end