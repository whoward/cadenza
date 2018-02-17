# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'generic block statements' do
  let(:parser) { Cadenza::Parser.new }

  it 'should parse a generic block' do
    expect_parsing('{% example %}foobar{% end %}').to equal_syntax_tree 'generic/basic.yml'
  end

  it 'should parse a generic block with parameters' do
    expect_parsing('{% filter escape %}<h1>Hello World!</h1>{% end %}').to equal_syntax_tree 'generic/with-params.yml'
  end
end
