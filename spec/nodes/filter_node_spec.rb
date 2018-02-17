# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::FilterNode do
  it 'should take an identifier' do
    filter = Cadenza::FilterNode.new('trim')

    expect(filter.identifier).to eq('trim')
  end

  it 'should be equal to another filter with the same name' do
    filter_a = Cadenza::FilterNode.new('trim')
    filter_b = Cadenza::FilterNode.new('trim')

    expect(filter_a).to eq(filter_b)
  end

  it 'should not equal another node with a different name' do
    filter_a = Cadenza::FilterNode.new('trim')
    filter_b = Cadenza::FilterNode.new('cut')

    expect(filter_a).not_to eq(filter_b)
  end

  it 'should equal a node with the same parameters' do
    filter_a = Cadenza::FilterNode.new('trim', [Cadenza::ConstantNode.new(10)])
    filter_b = Cadenza::FilterNode.new('trim', [Cadenza::ConstantNode.new(10)])

    expect(filter_a).to eq(filter_b)
  end

  it 'should not equal a node with different parameters' do
    filter_a = Cadenza::FilterNode.new('trim', [Cadenza::ConstantNode.new(10)])
    filter_b = Cadenza::FilterNode.new('trim', [Cadenza::ConstantNode.new(30)])

    expect(filter_a).not_to eq(filter_b)
  end

  it 'should take a list of parameter nodes' do
    constant_a = Cadenza::ConstantNode.new(10)

    filter = Cadenza::FilterNode.new('cut', [constant_a])

    expect(filter.identifier).to eq('cut')
    expect(filter.parameters).to eq([constant_a])
  end

  it 'should evaluate the filter on a value given a context' do
    klass = Class.new(Cadenza::Context)
    klass.define_filter(:floor) { |value, _params| value.floor }

    context = klass.new

    filter = Cadenza::FilterNode.new('floor')

    expect(filter.evaluate(context, 3.14159)).to eq(3)
  end

  it 'should pass parameters to the filter function when evaluating' do
    klass = Class.new(Cadenza::Context)
    klass.define_filter(:add) { |value, params| value + params.first }

    context = klass.new

    filter = Cadenza::FilterNode.new('add', [Cadenza::ConstantNode.new(1)])

    expect(filter.evaluate(context, 3.14159)).to eq(4.14159)
  end
end
