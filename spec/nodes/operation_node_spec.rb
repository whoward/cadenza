require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::OperationNode do
  subject { Cadenza::OperationNode }

  context 'equality' do
    it 'should equal a node with the same operands and operator' do
      variable = Cadenza::VariableNode.new('x')
      constant = Cadenza::ConstantNode.new(1)

      node_a = subject.new(variable, '==', constant)
      node_b = subject.new(variable, '==', constant)

      expect(node_a).to eq(node_b)
    end

    it 'should not equal a node with a different operator' do
      variable = Cadenza::VariableNode.new('x')
      constant = Cadenza::ConstantNode.new(1)

      node_a = subject.new(variable, '==', constant)
      node_b = subject.new(variable, '!=', constant)

      expect(node_a).not_to eq(node_b)
    end

    it 'should not equal a node with a different left side' do
      variable_a = Cadenza::VariableNode.new('x')
      variable_b = Cadenza::VariableNode.new('y')
      constant   = Cadenza::ConstantNode.new(1)

      node_a = subject.new(variable_a, '==', constant)
      node_b = subject.new(variable_b, '==', constant)

      expect(node_a).not_to eq(node_b)
    end

    it 'should not equal a node with a different right side' do
      variable = Cadenza::VariableNode.new('x')
      constant_a = Cadenza::ConstantNode.new(1)
      constant_b = Cadenza::ConstantNode.new(2)

      node_a = subject.new(variable, '==', constant_a)
      node_b = subject.new(variable, '==', constant_b)

      expect(node_a).not_to eq(node_b)
    end
  end

  context '#eval' do
    let(:ten)     { Cadenza::ConstantNode.new(10) }
    let(:twenty)  { Cadenza::ConstantNode.new(20) }
    let(:context) { Cadenza::Context.new }

    let(:true_condition)  { subject.new(twenty, '>', ten) }
    let(:false_condition) { subject.new(twenty, '<', ten) }

    it 'should evaluate equality operators' do
      expect(subject.new(ten, '==', twenty).eval(context)).to eq false
      expect(subject.new(ten, '==', ten).eval(context)).to eq true
    end

    it 'should evaluate inequality operators' do
      expect(subject.new(ten, '!=', twenty).eval(context)).to eq true
      expect(subject.new(ten, '!=', ten).eval(context)).to eq false
    end

    it 'should evaluate greater than or equal to operators' do
      expect(subject.new(ten,    '>=', twenty).eval(context)).to eq false
      expect(subject.new(ten,    '>=', ten).eval(context)).to eq true
      expect(subject.new(twenty, '>=', ten).eval(context)).to eq true
    end

    it 'should evaluate less than or equal to operators' do
      expect(subject.new(ten,    '<=', twenty).eval(context)).to eq true
      expect(subject.new(ten,    '<=', ten).eval(context)).to eq true
      expect(subject.new(twenty, '<=', ten).eval(context)).to eq false
    end

    it 'should evaluate less than operators' do
      expect(subject.new(ten,    '<', twenty).eval(context)).to eq true
      expect(subject.new(ten,    '<', ten).eval(context)).to eq false
      expect(subject.new(twenty, '<', ten).eval(context)).to eq false
    end

    it 'should evaluate greater than operators' do
      expect(subject.new(ten,    '>', twenty).eval(context)).to eq false
      expect(subject.new(ten,    '>', ten).eval(context)).to eq false
      expect(subject.new(twenty, '>', ten).eval(context)).to eq true
    end

    it "should evaluate 'and' conjunctions" do
      expect(subject.new(true_condition,  'and', true_condition).eval(context)).to eq true
      expect(subject.new(true_condition,  'and', false_condition).eval(context)).to eq false
      expect(subject.new(false_condition, 'and', true_condition).eval(context)).to  eq false
      expect(subject.new(false_condition, 'and', false_condition).eval(context)).to eq false
    end

    it "should evaluate 'or' conjunctions" do
      expect(subject.new(true_condition,  'or', true_condition).eval(context)).to eq true
      expect(subject.new(true_condition,  'or', false_condition).eval(context)).to eq true
      expect(subject.new(false_condition, 'or', true_condition).eval(context)).to  eq true
      expect(subject.new(false_condition, 'or', false_condition).eval(context)).to eq false
    end

    it 'should evaluate plus operators' do
      expect(subject.new(ten, '+', twenty).eval(context)).to eq(30)
    end

    it 'should evaluate minus operators' do
      expect(subject.new(twenty, '-', ten).eval(context)).to eq(10)
    end

    it 'should evaluate multiplication operators' do
      expect(subject.new(ten, '*', twenty).eval(context)).to eq(200)
    end

    it 'should evaluate division operators' do
      expect(subject.new(twenty, '/', ten).eval(context)).to eq(2)
    end
  end
end
