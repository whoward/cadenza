require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer, 'line and column counter' do
  before(:all) do
    @lexer = Cadenza::Lexer.new
  end

  it 'should start on column one, line one' do
    @lexer.source = ''
    @lexer.position.should == [1, 1]
  end

  it 'should advance the column counter as tokens are parsed' do
    @lexer.source = 'abc'
    @lexer.remaining_tokens
    @lexer.position.should == [1, 4]
  end

  it 'should advance the line counter as tokens are parsed' do
    @lexer.source = "abc\ndef"
    @lexer.remaining_tokens
    @lexer.position.should == [2, 4]
  end

  it 'should reset the counters each time something new is parsed' do
    @lexer.source = 'abcdef'
    @lexer.remaining_tokens

    @lexer.source = 'abc'
    @lexer.remaining_tokens

    @lexer.position.should == [1, 4]
  end

  it 'should count spacing with comments' do
    @lexer.source = "abc{# some\n comment\n #}def"
    @lexer.remaining_tokens

    @lexer.position.should == [3, 7]
  end

  it 'should count whitespace inside of statements' do
    @lexer.source = "{{ hello\nworld }}"
    @lexer.remaining_tokens

    @lexer.position.should == [2, 9]
  end
end
