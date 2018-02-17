# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::FilteredValueNode do
  subject { Cadenza::FilteredValueNode }

  let(:var_a) { Cadenza::VariableNode.new('foo') }
  let(:var_b) { Cadenza::VariableNode.new('bar') }

  let(:filter_a) { Cadenza::FilterNode.new('baz', [var_b]) }
  let(:filter_b) { Cadenza::FilterNode.new('baz', [var_a]) }

  context 'equivalence' do
    it 'equals a node with the same value and filters' do
      expect(subject.new(var_a, [filter_a])).to eq(subject.new(var_a, [filter_a]))
    end

    it "doesn't equal a node with a different value" do
      expect(subject.new(var_a)).not_to eq(subject.new(var_b))
    end

    it "doesn't equal a node with different filters" do
      expect(subject.new(var_a, [filter_a])).not_to eq(subject.new(var_a, [filter_b]))
    end
  end

  context 'evaluation' do
    let(:context_class) do
      klass = Class.new(Cadenza::Context)
      klass.define_filter(:floor) { |value, _params| value.floor }
      klass.define_filter(:add) { |value, params| value + params.first }
      klass
    end

    let(:context)      { context_class.new(pi: 3.14159) }
    let(:pi_node)      { Cadenza::VariableNode.new('pi') }
    let(:floor_node)   { Cadenza::FilterNode.new('floor') }
    let(:add_one_node) { Cadenza::FilterNode.new('add', [Cadenza::ConstantNode.new(1)]) }

    it "evaluates to the value's evaluation passed through each chained filter" do
      expect(subject.new(pi_node, [floor_node, add_one_node]).eval(context)).to eq(4)
    end
  end
end
