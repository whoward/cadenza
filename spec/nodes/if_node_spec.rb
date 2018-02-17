# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::IfNode do
  it 'should be equivalent to another node with the same expression and children' do
    text_a = Cadenza::TextNode.new('true')
    text_b = Cadenza::TextNode.new('false')

    var = Cadenza::VariableNode.new('bar')
    one = Cadenza::ConstantNode.new(1)
    expression = Cadenza::OperationNode.new(var, '==', one)

    node_a = Cadenza::IfNode.new(expression, [text_a], [text_b])
    node_b = Cadenza::IfNode.new(expression, [text_a], [text_b])

    expect(node_a).to eq(node_b)
  end

  it 'should not be equivalent to another node with a different expression' do
    text_a = Cadenza::TextNode.new('true')
    text_b = Cadenza::TextNode.new('false')

    var = Cadenza::VariableNode.new('bar')
    one = Cadenza::ConstantNode.new(1)
    two = Cadenza::ConstantNode.new(2)
    expression_a = Cadenza::OperationNode.new(var, '==', one)
    expression_b = Cadenza::OperationNode.new(var, '==', two)

    node_a = Cadenza::IfNode.new(expression_a, [text_a], [text_b])
    node_b = Cadenza::IfNode.new(expression_b, [text_a], [text_b])

    expect(node_a).not_to eq(node_b)
  end

  it 'should not be equivalent to another node with different true children' do
    text_a = Cadenza::TextNode.new('true')
    text_b = Cadenza::TextNode.new('false')
    text_c = Cadenza::TextNode.new('foo')

    var = Cadenza::VariableNode.new('bar')
    one = Cadenza::ConstantNode.new(1)
    expression = Cadenza::OperationNode.new(var, '==', one)

    node_a = Cadenza::IfNode.new(expression, [text_a], text_b)
    node_b = Cadenza::IfNode.new(expression, [text_c], [text_b])

    expect(node_a).not_to eq(node_b)
  end

  it 'should not be equivalent to another node with different false children' do
    text_a = Cadenza::TextNode.new('true')
    text_b = Cadenza::TextNode.new('false')
    text_c = Cadenza::TextNode.new('foo')

    var = Cadenza::VariableNode.new('bar')
    one = Cadenza::ConstantNode.new(1)
    expression = Cadenza::OperationNode.new(var, '==', one)

    node_a = Cadenza::IfNode.new(expression, [text_a], [text_b])
    node_b = Cadenza::IfNode.new(expression, [text_a], [text_c])

    expect(node_a).not_to eq(node_b)
  end

  it 'should assign an empty array to the children if not defined' do
    var = Cadenza::VariableNode.new('bar')
    one = Cadenza::ConstantNode.new(1)
    expression = Cadenza::OperationNode.new(var, '==', one)

    node = Cadenza::IfNode.new(expression)

    expect(node.true_children).to eq([])
    expect(node.false_children).to eq([])
  end

  context 'expression evaluation to retrieve correct children list' do
    let(:context) { Cadenza::Context.new }

    let(:pi)  { Cadenza::ConstantNode.new(3.14159) }
    let(:one) { Cadenza::ConstantNode.new(1) }

    let(:yup) { Cadenza::TextNode.new 'yup' }
    let(:nope) { Cadenza::TextNode.new 'nope' }

    it 'should return the true children if the expression evaluates to true' do
      node = Cadenza::IfNode.new(Cadenza::OperationNode.new(pi, '>', one), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([yup])
    end

    it 'should return the false children if the expression evaluates to false' do
      node = Cadenza::IfNode.new(Cadenza::OperationNode.new(pi, '<', one), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([nope])
    end

    it 'should return the true children if the expression evaluates to a non-blank string' do
      node = Cadenza::IfNode.new(Cadenza::ConstantNode.new('foo'), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([yup])
    end

    it 'should return the false children if the expression evaluates to an empty string' do
      node = Cadenza::IfNode.new(Cadenza::ConstantNode.new(''), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([nope])
    end

    it 'should return the false children if the expression evaluates to a whitespace string' do
      node = Cadenza::IfNode.new(Cadenza::ConstantNode.new("\t\n   "), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([nope])
    end

    it 'should return the true children if the expression evaluates to a nonzero number' do
      node = Cadenza::IfNode.new(Cadenza::ConstantNode.new(10), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([yup])
    end

    it 'should return the false children if the expression evaluates to a zero number' do
      node = Cadenza::IfNode.new(Cadenza::ConstantNode.new(0), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([nope])
    end

    it 'should return the appropriate children for the expression coerced to a boolean' do
      node = Cadenza::IfNode.new(Cadenza::ConstantNode.new(nil), [yup], [nope])

      expect(node.evaluate_expression_for_children(context)).to eq([nope])
    end
  end
end
