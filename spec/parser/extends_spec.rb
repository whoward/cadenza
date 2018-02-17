# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'extends statement' do
  it 'should assign the string value to the document' do
    expect_parsing("{% extends 'foo' %}").to equal_syntax_tree 'extends/string.yml'
  end

  it 'should assign the variable value to the document' do
    expect_parsing('{% extends somefile %}').to equal_syntax_tree 'extends/variable.yml'
  end
end
