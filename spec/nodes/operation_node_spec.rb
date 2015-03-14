require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::OperationNode do

   subject { Cadenza::OperationNode }

   context "equality" do
      it "should equal a node with the same operands and operator" do
         variable = Cadenza::VariableNode.new("x")
         constant = Cadenza::ConstantNode.new(1)

         node_a = subject.new(variable, "==", constant)
         node_b = subject.new(variable, "==", constant)

         node_a.should == node_b
      end

      it "should not equal a node with a different operator" do
         variable = Cadenza::VariableNode.new("x")
         constant = Cadenza::ConstantNode.new(1)

         node_a = subject.new(variable, "==", constant)
         node_b = subject.new(variable, "!=", constant)

         node_a.should_not == node_b
      end

      it "should not equal a node with a different left side" do
         variable_a = Cadenza::VariableNode.new("x")
         variable_b = Cadenza::VariableNode.new("y")
         constant   = Cadenza::ConstantNode.new(1)

         node_a = subject.new(variable_a, "==", constant)
         node_b = subject.new(variable_b, "==", constant)

         node_a.should_not == node_b
      end

      it "should not equal a node with a different right side" do
         variable = Cadenza::VariableNode.new("x")
         constant_a = Cadenza::ConstantNode.new(1)
         constant_b = Cadenza::ConstantNode.new(2)

         node_a = subject.new(variable, "==", constant_a)
         node_b = subject.new(variable, "==", constant_b)

         node_a.should_not == node_b
      end
   end

   context "#implied_globals" do
      it "should use the union of it's left and right node's implied globals for it's own implied globals" do
         variable_a = Cadenza::VariableNode.new("a")
         variable_b = Cadenza::VariableNode.new("b")

         boolean_a = subject.new(variable_a, "==", variable_b)
         boolean_b = subject.new(variable_a, "==", variable_a)

         boolean_a.implied_globals.should == %w(a b)
         boolean_b.implied_globals.should == %w(a)
      end
   end

   context "#eval" do
      let(:ten)     { Cadenza::ConstantNode.new(10) }
      let(:twenty)  { Cadenza::ConstantNode.new(20) }
      let(:context) { Cadenza::Context.new }

      let(:true_condition)  { subject.new(twenty, '>', ten) }
      let(:false_condition) { subject.new(twenty, '<', ten) }

      it "should evaluate equality operators" do
         subject.new(ten, '==', twenty).eval(context).should be_false
         subject.new(ten, '==', ten).eval(context).should be_true
      end

      it "should evaluate inequality operators" do
         subject.new(ten, '!=', twenty).eval(context).should be_true
         subject.new(ten, '!=', ten).eval(context).should be_false
      end

      it "should evaluate greater than or equal to operators" do
         subject.new(ten,    '>=', twenty).eval(context).should be_false
         subject.new(ten,    '>=', ten).eval(context).should be_true
         subject.new(twenty, '>=', ten).eval(context).should be_true
      end

      it "should evaluate less than or equal to operators" do
         subject.new(ten,    '<=', twenty).eval(context).should be_true
         subject.new(ten,    '<=', ten).eval(context).should be_true
         subject.new(twenty, '<=', ten).eval(context).should be_false         
      end

      it "should evaluate less than operators" do
         subject.new(ten,    '<', twenty).eval(context).should be_true
         subject.new(ten,    '<', ten).eval(context).should be_false
         subject.new(twenty, '<', ten).eval(context).should be_false         
      end

      it "should evaluate greater than operators" do
         subject.new(ten,    '>', twenty).eval(context).should be_false
         subject.new(ten,    '>', ten).eval(context).should be_false
         subject.new(twenty, '>', ten).eval(context).should be_true         
      end

      it "should evaluate 'and' conjunctions" do
         subject.new(true_condition,  'and', true_condition).eval(context).should  be_true
         subject.new(true_condition,  'and', false_condition).eval(context).should be_false
         subject.new(false_condition, 'and', true_condition).eval(context).should  be_false
         subject.new(false_condition, 'and', false_condition).eval(context).should be_false
      end

      it "should evaluate 'or' conjunctions" do
         subject.new(true_condition,  'or', true_condition).eval(context).should  be_true
         subject.new(true_condition,  'or', false_condition).eval(context).should be_true
         subject.new(false_condition, 'or', true_condition).eval(context).should  be_true
         subject.new(false_condition, 'or', false_condition).eval(context).should be_false
      end

      it "should evaluate plus operators" do
         subject.new(ten, '+', twenty).eval(context).should == 30
      end

      it "should evaluate minus operators" do
         subject.new(twenty, '-', ten).eval(context).should == 10
      end

      it "should evaluate multiplication operators" do
         subject.new(ten, '*', twenty).eval(context).should == 200
      end

      it "should evaluate division operators" do
         subject.new(twenty, '/', ten).eval(context).should == 2
      end

   end
end