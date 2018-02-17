# frozen_string_literal: true

require 'yaml'

class FixtureSyntaxTree
  attr_reader :document

  def initialize(filename)
    @document = parse_fixture('DocumentNode', YAML.load_file(Fixture.filename(filename))['DocumentNode'])
  end

  def equals(document)
    @document == document
  end

  private

  def parse_fixture(type, node)
    case type
    when 'DocumentNode' then parse_document_node(node)
    when 'ConstantNode' then parse_constant_node(node)
    when 'FilterNode' then parse_filter_node(node)
    when 'VariableNode' then parse_variable_node(node)
    when 'FilteredValueNode' then parse_filtered_value_node(node)
    when 'OperationNode' then parse_operation_node(node)
    when 'TextNode' then parse_text_node(node)
    when 'IfNode' then parse_if_node(node)
    when 'ForNode' then parse_for_node(node)
    when 'BlockNode' then parse_block_node(node)
    when 'GenericBlockNode' then parse_generic_block_node(node)
    when 'BooleanInverseNode' then parse_boolean_inverse_node(node)
    else raise "unknown type: #{type}"
    end
  end

  def parse_document_node(node)
    parsed_node = Cadenza::DocumentNode.new
    parsed_node.children = list_for_key(node, 'children')

    if node.key?('extends')
      parsed_node.extends = node['extends'].is_a?(String) ? node['extends'] : node_for_key(node, 'extends')
    end

    parsed_node.blocks = hash_for_key(node, 'blocks') if node.key?('blocks')

    parsed_node
  end

  def parse_constant_node(node)
    Cadenza::ConstantNode.new(node['value'])
  end

  def parse_filter_node(node)
    identifier = node['identifier']
    parameters = list_for_key(node, 'parameters')

    Cadenza::FilterNode.new(identifier, parameters)
  end

  def parse_variable_node(node)
    parameters = list_for_key(node, 'parameters')

    Cadenza::VariableNode.new(node['value'], parameters)
  end

  def parse_filtered_value_node(node)
    value = node_for_key(node, 'value')
    filters = list_for_key(node, 'filters')

    Cadenza::FilteredValueNode.new(value, filters)
  end

  def parse_operation_node(node)
    left = node_for_key(node, 'left')
    right = node_for_key(node, 'right')

    Cadenza::OperationNode.new(left, node['operator'], right)
  end

  def parse_text_node(node)
    Cadenza::TextNode.new(node['text'])
  end

  def parse_if_node(node)
    expression     = node_for_key(node, 'expression')
    true_children  = list_for_key(node, 'true_children')
    false_children = list_for_key(node, 'false_children')

    Cadenza::IfNode.new(expression, true_children, false_children)
  end

  def parse_for_node(node)
    iterator = node_for_key(node, 'iterator')
    iterable = node_for_key(node, 'iterable')
    children = list_for_key(node, 'children')

    Cadenza::ForNode.new(iterator, iterable, children)
  end

  def parse_block_node(node)
    name     = node['name']
    children = list_for_key(node, 'children')

    Cadenza::BlockNode.new(name, children)
  end

  def parse_generic_block_node(node)
    identifier = node['identifier']
    children   = list_for_key(node, 'children')
    parameters = list_for_key(node, 'parameters')

    Cadenza::GenericBlockNode.new(identifier, children, parameters)
  end

  def parse_boolean_inverse_node(node)
    expression = node_for_key(node, 'expression')

    Cadenza::BooleanInverseNode.new(expression)
  end

  def node_for_key(node, key)
    type = node[key].keys.first
    parse_fixture(type, node[key][type])
  end

  def hash_for_key(node, key)
    result = {}
    parent = node[key]

    parent.each_key do |name|
      result[name] = node_for_key(parent, name)
    end

    result
  end

  def list_for_key(node, key)
    (node[key] || []).map do |child|
      type = child.keys.first
      inner_node = child[type]
      parse_fixture(type, inner_node)
    end
  end
end
