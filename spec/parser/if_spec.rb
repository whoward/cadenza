# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'if statements' do
  it 'should parse an if statement' do
    expect_parsing('{% if foo %}bar{% endif %}').to equal_syntax_tree 'if/basic.yml'
  end

  it 'should parse an if/else statement' do
    expect_parsing('{% if foo %}bar{% else %}baz{% endif %}').to equal_syntax_tree 'if/else.yml'
  end

  it 'should parse an if statement with no true content' do
    expect_parsing('{% if foo %}{% endif %}').to equal_syntax_tree 'if/empty.yml'
  end

  it 'should parse an if statement with no true content and an else block' do
    expect_parsing('{% if foo %}{% else %}bar{% endif %}').to equal_syntax_tree 'if/empty_true.yml'
  end

  it 'should parse an if statement with true content but no false content' do
    expect_parsing('{% if foo %}bar{% else %}{% endif %}').to equal_syntax_tree 'if/empty_false.yml'
  end
end
