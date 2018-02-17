# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::VariableNode do
  subject { Cadenza::VariableNode }

  context 'equivalence' do
    it 'equals a node with the same name' do
      expect(Cadenza::VariableNode.new('foo')).to eq(Cadenza::VariableNode.new('foo'))
    end

    it "doesn't equal a node with a different name" do
      expect(Cadenza::VariableNode.new('foo')).not_to eq(Cadenza::VariableNode.new('bar'))
    end

    it "doesn't equal a node with different parameters" do
      var_a = Cadenza::VariableNode.new('load', [Cadenza::ConstantNode.new('mytemplate')])
      var_b = Cadenza::VariableNode.new('load', [Cadenza::ConstantNode.new('foo')])

      expect(var_a).not_to eq(var_b)
    end
  end

  context 'evaluation' do
    let(:context_class) do
      klass = Class.new(Cadenza::Context)
      klass.define_function(:ctx, &:inspect) # output's the inspected context
      klass.define_function(:load) { |_context, template| template == 'foo' ? 'bar' : 'baz' } # fake load method
      klass
    end

    let(:context)      { context_class.new(pi: 3.14159) }
    let(:pi_node)      { Cadenza::VariableNode.new('pi') }
    let(:ctx_node)     { Cadenza::VariableNode.new('ctx') }

    it 'evaluates to the value looked up in the context' do
      expect(Cadenza::VariableNode.new('pi').eval(context)).to eq(3.14159)
    end

    it "evaluates a functional variables's value" do
      expect(Cadenza::VariableNode.new('ctx').eval(context)).to eq(context.inspect)
    end

    it "evaluates a functional variable's value given parameters" do
      template_a = Cadenza::ConstantNode.new('foo')
      template_b = Cadenza::ConstantNode.new('abc')

      expect(Cadenza::VariableNode.new('load', [template_a]).eval(context)).to eq('bar')
      expect(Cadenza::VariableNode.new('load', [template_b]).eval(context)).to eq('baz')
    end
  end
end
