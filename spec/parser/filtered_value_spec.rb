require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'filtered value nodes' do
  it 'parses an inject statement with one filter' do
    expect_parsing('{{ name | trim }}').to equal_syntax_tree 'filtered_value/single_filter.yml'
  end

  it 'parses an inject statement with multiple filters' do
    expect_parsing('{{ name | trim | upcase }}').to equal_syntax_tree 'filtered_value/multiple_filters.yml'
  end

  it 'parses a single param' do
    expect_parsing('{{ name | cut: 5 }}').to equal_syntax_tree 'filtered_value/single_filter_with_single_param.yml'
  end

  it 'parses multiple params' do
    expect_parsing("{{ name | somefilter: 'foo', 3.14159 }}").to \
      equal_syntax_tree 'filtered_value/single_filter_with_multiple_params.yml'
  end

  it 'parses multiple filters with multiple params' do
    expect_parsing("{{ name | trim | somefilter: 'foo', 3.14159 }}").to \
      equal_syntax_tree 'filtered_value/multiple_filters_with_params.yml'
  end
end
