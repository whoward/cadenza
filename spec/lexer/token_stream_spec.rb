require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer, 'token parsing' do
  subject { tokens_for(input) }

  let(:lexer) { Cadenza::Lexer.new }

  def tokenize(string)
    lexer.source = string
    lexer.remaining_tokens.map { |type, token| [type, token.is_a?(Cadenza::Token) ? token.value : token] }
  end

  def tokens_for(string)
    tokenize(string).map(&:first)
  end

  context 'with an empty string' do
    let(:input) { '' }
    it { is_expected.to eq [false] }
  end

  context 'with a nil input' do
    let(:input) { nil }
    it { is_expected.to eq [false] }
  end

  context 'with a block of text' do
    let(:input) { 'abc' }
    it { is_expected.to eq [:TEXT_BLOCK, false] }
  end

  context 'with an opening injection token' do
    let(:input) { '{{' }
    it { is_expected.to eq [:VAR_OPEN, false] }
  end

  context 'with an ending injection token' do
    let(:input) { '{{ }}' }
    it { is_expected.to eq [:VAR_OPEN, :VAR_CLOSE, false] }
  end

  context 'with an opening statement token' do
    let(:input) { '{%' }
    it { is_expected.to eq [:STMT_OPEN, false] }
  end

  context 'with an ending statement token' do
    let(:input) { '{% %}' }
    it { is_expected.to eq [:STMT_OPEN, :STMT_CLOSE, false] }
  end

  context 'with comments in the input' do
    let(:input) { '{# hello #}' }
    it { is_expected.to eq [false] }
  end

  context 'with an unsigned integer literal' do
    let(:input) { '{{ 3 }}' }
    it { is_expected.to eq [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false] }
  end

  context 'with a positive integer literal' do
    let(:input) { '{{ +3 }}' }
    it { is_expected.to eq [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false] }
  end

  context 'with a negative integer literal' do
    let(:input) { '{{ -3 }}' }
    it { is_expected.to eq [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false] }
  end

  context 'with an unsigned real literal' do
    let(:input) { '{{ 3.14 }}' }
    it { is_expected.to eq [:VAR_OPEN, :REAL, :VAR_CLOSE, false] }
  end

  context 'with a positive real literal' do
    let(:input) { '{{ +3.14 }}' }
    it { is_expected.to eq [:VAR_OPEN, :REAL, :VAR_CLOSE, false] }
  end

  context 'with a single quoted string literal' do
    let(:input) { "{{ '3' }}" }
    it { is_expected.to eq [:VAR_OPEN, :STRING, :VAR_CLOSE, false] }
  end

  context 'with a double quoted string literal' do
    let(:input) { '{{ "3" }}' }
    it { is_expected.to eq [:VAR_OPEN, :STRING, :VAR_CLOSE, false] }
  end

  describe 'string escapes' do
    subject { tokenize(input).at(1) }

    context 'with an escaped double quote' do
      let(:input) { '{{ "\"" }}' }
      it { is_expected.to eq [:STRING, '"'] }
    end

    context 'with an escaped carriage return' do
      let(:input) { '{{ "\r" }}' }
      it { is_expected.to eq [:STRING, "\r"] }
    end

    context 'with an escaped line feed' do
      let(:input) { '{{ "\n" }}' }
      it { is_expected.to eq [:STRING, "\n"] }
    end

    context 'with an escaped tab' do
      let(:input) { '{{ "\t" }}' }
      it { is_expected.to eq [:STRING, "\t"] }
    end

    context 'with a escaped slash' do
      let(:input) { '{{ "\\\\" }}' }
      it { is_expected.to eq [:STRING, '\\'] }
    end

    context 'with an escaped UTF code' do
      let(:input) { '{{ "\\u03A9" }}' }
      it { is_expected.to eq [:STRING, ['03A9'.to_i(16)].pack('U')] }
    end

    context 'with an escaped character inside a single quoted string' do
      let(:input) { %q({{ '\"' }}) }
      it { is_expected.to eq [:STRING, '\"'] }
    end
  end

  context 'with a single identifier' do
    let(:input) { '{{ foo }}' }
    it { is_expected.to eq [:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false] }
  end

  context 'with an identifier with multiple dots in it' do
    let(:input) { '{{ foo.bar }}' }
    it { is_expected.to eq [:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false] }
  end

  Cadenza::Lexer::KEYWORDS.each do |keyword|
    context "with the #{keyword.inspect} keyword" do
      let(:input) { "{% #{keyword} %}" }
      it { is_expected.to eq [:STMT_OPEN, keyword.upcase.to_sym, :STMT_CLOSE, false] }
    end
  end

  context 'identifiers starting with END' do
    subject { tokenize(input).at(1) }
    let(:input) { '{% endfilter %}' }
    it { is_expected.to eq [:END, 'ENDFILTER'] }
  end

  context 'with no whitespace inside of a inject' do
    let(:input) { '{{3}}' }
    it { is_expected.to eq [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false] }
  end

  context 'with no whitespace inside of a statement' do
    let(:input) { '{%3%}' }
    it { is_expected.to eq [:STMT_OPEN, :INTEGER, :STMT_CLOSE, false] }
  end

  context 'with an identifier that starts with a keyword' do
    let(:input) { '{{ forloop }}' }
    it { is_expected.to eq [:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false] }
  end

  context 'with the equivalence operator' do
    let(:input) { '{% == %}' }
    it { is_expected.to eq [:STMT_OPEN, :OP_EQ, :STMT_CLOSE, false] }
  end

  context 'with the inequivalence operator' do
    let(:input) { '{% != %}' }
    it { is_expected.to eq [:STMT_OPEN, :OP_NEQ, :STMT_CLOSE, false] }
  end

  context 'with the greater than or equal to operator' do
    let(:input) { '{% >= %}' }
    it { is_expected.to eq [:STMT_OPEN, :OP_GEQ, :STMT_CLOSE, false] }
  end

  context 'with the less than or equal to operator' do
    let(:input) { '{% <= %}' }
    it { is_expected.to eq [:STMT_OPEN, :OP_LEQ, :STMT_CLOSE, false] }
  end

  context 'with the greater than operator' do
    let(:input) { '{% if foo > 0 %}' }
    it { is_expected.to eq [:STMT_OPEN, :IF, :IDENTIFIER, '>', :INTEGER, :STMT_CLOSE, false] }
  end

  context 'with the less than operator' do
    let(:input) { '{% if foo < 0 %}' }
    it { is_expected.to eq [:STMT_OPEN, :IF, :IDENTIFIER, '<', :INTEGER, :STMT_CLOSE, false] }
  end
end
