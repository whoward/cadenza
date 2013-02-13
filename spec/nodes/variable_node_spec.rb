require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::VariableNode do
   subject { Cadenza::VariableNode }

   context "equivalence" do
      it "equals a node with the same name" do
         Cadenza::VariableNode.new("foo").should == Cadenza::VariableNode.new("foo")
      end

      it "doesn't equal a node with a different name" do
         Cadenza::VariableNode.new("foo").should_not == Cadenza::VariableNode.new("bar")
      end

      it "doesn't equal a node with different parameters" do
         var_a = Cadenza::VariableNode.new('load', [Cadenza::ConstantNode.new("mytemplate")])
         var_b = Cadenza::VariableNode.new('load', [Cadenza::ConstantNode.new("foo")])

         var_a.should_not == var_b
      end
   end

   context "#implied_globals" do
      it "returns a list containing the identifier name" do
         Cadenza::VariableNode.new("foo").implied_globals.should == %w(foo)
      end

      it "returns the parameters' implied globals as well" do
         x = Cadenza::VariableNode.new("x")

         Cadenza::VariableNode.new("foo", [x, x]).implied_globals.should == %w(foo x)
      end
   end

   context "evaluation" do
      let(:context_class) do
         klass = Class.new(Cadenza::Context)
         klass.define_functional_variable(:ctx) {|context| context.inspect } # output's the inspected context
         klass.define_functional_variable(:load) {|context, template| template == "foo" ? "bar" : "baz" } # fake load method
         klass
      end

      let(:context)      { context_class.new(:pi => 3.14159) }
      let(:pi_node)      { Cadenza::VariableNode.new("pi") }
      let(:ctx_node)     { Cadenza::VariableNode.new("ctx") }

      it "evaluates to the value looked up in the context" do
         Cadenza::VariableNode.new("pi").eval(context).should == 3.14159
      end

      it "evaluates a functional variables's value" do
         Cadenza::VariableNode.new("ctx").eval(context).should == context.inspect
      end
      
      it "evaluates a functional variable's value given parameters" do
         template_a = Cadenza::ConstantNode.new("foo")
         template_b = Cadenza::ConstantNode.new("abc")

         Cadenza::VariableNode.new("load", [template_a]).eval(context).should == "bar"
         Cadenza::VariableNode.new("load", [template_b]).eval(context).should == "baz"
      end
   end

end