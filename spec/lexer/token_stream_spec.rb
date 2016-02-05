require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer, 'token parsing' do
  before(:all) do
    @lexer = Cadenza::Lexer.new
  end

  def tokenize(string)
    @lexer.source = string
    @lexer.remaining_tokens.map { |type, token| [type, token.is_a?(Cadenza::Token) ? token.value : token] }
  end

  def tokens_for(string)
    tokenize(string).map(&:first)
  end

  def values_for(string)
    tokenize(string).map(&:last)
  end

  it 'should return a end token for an empty string' do
    expect(tokens_for('')).to eq([false])
    expect(tokens_for(nil)).to eq([false])
  end

  it 'should parse blocks of text' do
    expect(tokens_for('abc')).to eq([:TEXT_BLOCK, false])
  end

  it 'should parse an opening injection token' do
    expect(tokens_for('{{')).to eq([:VAR_OPEN, false])
  end

  it 'should parse an ending injection token' do
    expect(tokens_for('{{}}')).to eq([:VAR_OPEN, :VAR_CLOSE, false])
  end

  it 'should parse an opening statement token' do
    expect(tokens_for('{%')).to eq([:STMT_OPEN, false])
  end

  it 'should parse an ending statement token' do
    expect(tokens_for('{%%}')).to eq([:STMT_OPEN, :STMT_CLOSE, false])
  end

  it 'should not parse comments' do
    expect(tokens_for('{# hello #}')).to eq([false])
  end

  it 'should parse constants' do
    expect(tokens_for('{{3}}')).to eq([:VAR_OPEN, :INTEGER, :VAR_CLOSE, false])
    expect(tokens_for('{{+3}}')).to eq([:VAR_OPEN, :INTEGER, :VAR_CLOSE, false])
    expect(tokens_for('{{-3}}')).to eq([:VAR_OPEN, :INTEGER, :VAR_CLOSE, false])

    expect(tokens_for('{{3.14}}')).to eq([:VAR_OPEN, :REAL, :VAR_CLOSE, false])
    expect(tokens_for('{{+3.14}}')).to eq([:VAR_OPEN, :REAL,    :VAR_CLOSE, false])
    expect(tokens_for('{{-3.14}}')).to eq([:VAR_OPEN, :REAL,    :VAR_CLOSE, false])

    expect(tokens_for("{{'3'}}")).to eq([:VAR_OPEN, :STRING, :VAR_CLOSE, false])
    expect(tokens_for('{{"3"}}')).to eq([:VAR_OPEN, :STRING,  :VAR_CLOSE, false])
  end

  it 'should parse string escapes inside double quotes only' do
    expect(tokenize('{{ "\"" }}').at(1)).to      eq([:STRING, '"'])
    expect(tokenize('{{ "\r" }}').at(1)).to      eq([:STRING, "\r"])
    expect(tokenize('{{ "\n" }}').at(1)).to      eq([:STRING, "\n"])
    expect(tokenize('{{ "\t" }}').at(1)).to      eq([:STRING, "\t"])
    expect(tokenize('{{ "\\\\" }}').at(1)).to    eq([:STRING, '\\'])
    expect(tokenize('{{ "\\u03A9" }}').at(1)).to eq([:STRING, ['03A9'.to_i(16)].pack('U')])

    expect(tokenize(%q({{ '\"' }})).at(1)).to eq([:STRING, '\"'])
  end

  it 'should scan identifiers' do
    expect(tokens_for('{{foo}}')).to eq([:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false])
    expect(tokens_for('{{foo.bar}}')).to eq([:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false])
  end

  it 'should scan keywords' do
    expect(tokens_for('{%if%}')).to        eq([:STMT_OPEN, :IF, :STMT_CLOSE, false])
    expect(tokens_for('{%else%}')).to      eq([:STMT_OPEN, :ELSE, :STMT_CLOSE, false])
    expect(tokens_for('{%endif%}')).to     eq([:STMT_OPEN, :ENDIF, :STMT_CLOSE, false])
    expect(tokens_for('{%for%}')).to       eq([:STMT_OPEN, :FOR, :STMT_CLOSE, false])
    expect(tokens_for('{%in%}')).to        eq([:STMT_OPEN, :IN, :STMT_CLOSE, false])
    expect(tokens_for('{%endfor%}')).to    eq([:STMT_OPEN, :ENDFOR, :STMT_CLOSE, false])
    expect(tokens_for('{%block%}')).to     eq([:STMT_OPEN, :BLOCK, :STMT_CLOSE, false])
    expect(tokens_for('{%endblock%}')).to  eq([:STMT_OPEN, :ENDBLOCK, :STMT_CLOSE, false])
    expect(tokens_for('{%extends%}')).to   eq([:STMT_OPEN, :EXTENDS, :STMT_CLOSE, false])
    expect(tokens_for('{%end%}')).to       eq([:STMT_OPEN, :END, :STMT_CLOSE, false])
    expect(tokens_for('{%and%}')).to       eq([:STMT_OPEN, :AND, :STMT_CLOSE, false])
    expect(tokens_for('{%or%}')).to        eq([:STMT_OPEN, :OR, :STMT_CLOSE, false])
    expect(tokens_for('{%not%}')).to       eq([:STMT_OPEN, :NOT, :STMT_CLOSE, false])
    expect(tokens_for('{%unless%}')).to    eq([:STMT_OPEN, :UNLESS, :STMT_CLOSE, false])
    expect(tokens_for('{%endunless%}')).to eq([:STMT_OPEN, :ENDUNLESS, :STMT_CLOSE, false])
  end

  it 'scans any identifier starting with END as an END token with the value of the full keyword' do
    expect(tokenize('{% endfilter %}').at(1)).to eq([:END, 'ENDFILTER'])
  end

  it 'should ignore whitespace inside of statements' do
    expect(tokens_for('{{ 3 }}')).to eq([:VAR_OPEN, :INTEGER, :VAR_CLOSE, false])
    expect(tokens_for('{% 3.14 %}')).to eq([:STMT_OPEN, :REAL, :STMT_CLOSE, false])
  end

  it 'should scan identifiers that start with keywords as identifiers' do
    expect(tokens_for('{{ forloop }}')).to eq([:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false])
  end

  it 'should scan the equivalence operator' do
    expect(tokens_for('{% == %}')).to eq([:STMT_OPEN, :OP_EQ, :STMT_CLOSE, false])
  end

  it 'should scan the inequivalence operator' do
    expect(tokens_for('{% != %}')).to eq([:STMT_OPEN, :OP_NEQ, :STMT_CLOSE, false])
  end

  it 'should scan the greater than or equal to operator' do
    expect(tokens_for('{% >= %}')).to eq([:STMT_OPEN, :OP_GEQ, :STMT_CLOSE, false])
  end

  it 'should scan the less than or equal to operator' do
    expect(tokens_for('{% <= %}')).to eq([:STMT_OPEN, :OP_LEQ, :STMT_CLOSE, false])
  end

  it 'should match individual characters inside of statements' do
    expect(tokens_for('{% if foo > 0 %}')).to eq([:STMT_OPEN, :IF, :IDENTIFIER, '>', :INTEGER, :STMT_CLOSE, false])
  end
end
