require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'variable nodes' do
  it 'parses an identifier token into a variable node' do
    expect_parsing('{{ foo }}').to equal_syntax_tree 'variable/basic.yml'
  end

  context 'functional inject statements' do
    it 'should parse one' do
      expect_parsing("{{ load 'mytemplate' }}").to equal_syntax_tree 'variable/functional.yml'
    end

    it 'should parse one with complex params' do
      expect_parsing("{{ load 'mytemplate', x + 123 }}").to equal_syntax_tree 'variable/functional-multiple-params.yml'
    end
  end
end
