require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer, 'line and column counter' do
  subject { lexer.position }

  let(:lexer) { Cadenza::Lexer.new }

  let(:source) { '' }

  before { lexer.source = source }

  context 'in the initial state' do
    it { is_expected.to eq [1, 1] }
  end

  context 'after the tokens have been consumed' do
    before { lexer.remaining_tokens }

    context 'with a text token' do
      let(:source) { 'abc' }
      it { is_expected.to eq [1, 4] }
    end

    context 'with a newline in the text token' do
      let(:source) { "abc\ndef" }
      it { is_expected.to eq [2, 4] }
    end

    context 'with a comment in the template' do
      let(:source) { "abc{# some\n comment\n #}def" }
      it { is_expected.to eq [3, 7] }
    end

    context 'with significant whitespace inside of statements' do
      let(:source) { "{{ hello\nworld }}" }
      it { is_expected.to eq [2, 9] }
    end

    context 'after resetting the source' do
      let(:source) { 'abcdef' }

      it 'resets the counter' do
        expect(subject).to eq [1, 7]

        lexer.source = 'abc'
        lexer.remaining_tokens
        expect(lexer.position).to eq [1, 4]
      end
    end
  end
end
