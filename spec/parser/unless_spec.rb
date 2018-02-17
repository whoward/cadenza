# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'unless statements' do
  it 'should parse an unless statement' do
    expect_parsing('{% unless foo %}bar{% endunless %}').to equal_syntax_tree 'unless/basic.yml'
  end

  it 'should parse an if/else statement' do
    expect_parsing('{% unless foo %}bar{% else %}baz{% endunless %}').to equal_syntax_tree 'unless/else.yml'
  end

  it 'should parse an if statement with no true content' do
    expect_parsing('{% unless foo %}{% endunless %}').to equal_syntax_tree 'unless/empty.yml'
  end

  it 'should parse an if statement with no true content and an else block' do
    expect_parsing('{% unless foo %}{% else %}bar{% endunless %}').to equal_syntax_tree 'unless/empty_true.yml'
  end

  it 'should parse an if statement with true content but no false content' do
    expect_parsing('{% unless foo %}bar{% else %}{% endunless %}').to equal_syntax_tree 'unless/empty_false.yml'
  end
end
