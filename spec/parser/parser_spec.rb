require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser do
  class FakeLexer
  end

  class PartialLexer
    def next_token
      [false, false]
    end
  end

  class AnotherLexer
    def next_token
      [false, false]
    end

    def source=(source)
    end
  end

  it 'should assign a default lexer, which is an instance of Cadenza::Lexer' do
    parser = Cadenza::Parser.new
    expect(parser.lexer).to be_an_instance_of Cadenza::Lexer
  end

  it 'should allow overriding the default lexer in the initializer' do
    parser = Cadenza::Parser.new(lexer: AnotherLexer.new)
    expect(parser.lexer).to be_an_instance_of AnotherLexer
  end

  it 'should raise an exception if the lexer does not have next_token defined' do
    expect do
      Cadenza::Parser.new(lexer: FakeLexer.new)
    end.to raise_error 'Lexers passed to the parser must define next_token'
  end

  it 'should raise an exception if the lexer does not have source= defined' do
    expect do
      Cadenza::Parser.new(lexer: PartialLexer.new)
    end.to raise_error 'Lexers passed to the parser must define source='
  end

  it 'should parse an empty stream as an empty document node' do
    expect_parsing('').to equal_syntax_tree 'empty.yml'
  end

  it 'should raise a Cadenza::ParseError when attempting to parse an invalid template' do
    parser = Cadenza::Parser.new

    expect do
      parser.parse 'foo {{ bar'
    end.to raise_error Cadenza::ParseError
  end
end
