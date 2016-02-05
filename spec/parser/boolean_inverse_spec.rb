require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'boolean inverse parsing' do
  it 'should parse an inverse' do
    expect_parsing('{{ not x }}').to equal_syntax_tree 'inverse/not_x.yml'
  end
end
