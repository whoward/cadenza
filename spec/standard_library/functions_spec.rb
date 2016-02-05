require 'spec_helper'

describe Cadenza::StandardLibrary::Functions do
  subject { Cadenza::StandardLibrary }

  let(:context) { Cadenza::BaseContext.new }

  before { context.add_loader Cadenza::FilesystemLoader.new(Fixture.filename('templates')) }
  after  { context.clear_loaders }

  context 'load' do
    it 'should return the source of the given file without parsing it' do
      expect(subject.evaluate_function(:load, context, ['index.html.cadenza'])).to eq(Fixture.read('templates/index.html.cadenza'))
    end

    it 'should return nil if the given file does not exist' do
      expect(subject.evaluate_function(:load, context, ['fake.html'])).to be_nil
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_function(:load, context, [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a string' do
      expect do
        subject.evaluate_function(:load, context, [123])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'render' do
    before { context.push pi: 'def' }
    after { context.pop }

    it 'should return the rendered content of the given file' do
      expect(subject.evaluate_function(:render, context, ['test.html.cadenza'])).to eq('abcdefghi')
    end

    it 'should return empty text if the template does not exist' do
      expect(subject.evaluate_function(:render, context, ['fake.html'])).to eq('')
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_function(:render, context, [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a string' do
      expect do
        subject.evaluate_function(:render, context, [123])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end
end
