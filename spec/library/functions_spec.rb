require 'spec_helper'

describe Cadenza::Library::Functions do
  let(:library) do
    Cadenza::Library.build do
      define_function(:assign) { |context, name, value| context.assign(name, value) }
    end
  end

  let(:context) { Cadenza::Context.new }

  context '#define_function' do
    it 'should allow defining a function' do
      expect(library.functions[:assign]).to be_a(Proc)
    end

    it 'should evaluate a function' do
      expect(context.lookup('foo')).to be_nil

      library.evaluate_function(:assign, context, ['foo', 123])

      expect(context.lookup('foo')).to eq(123)
    end

    it 'should raise a FunctionNotDefinedError if the function is not defined' do
      expect do
        library.evaluate_function(:foo, [])
      end.to raise_error Cadenza::FunctionNotDefinedError
    end
  end

  context '#lookup_function' do
    it 'returns the given function' do
      expect(library.lookup_function(:assign)).to be_a Proc
    end

    it 'raises a FunctionNotDefinedError if the block is not defined' do
      expect do
        library.lookup_function(:fake)
      end.to raise_error Cadenza::FunctionNotDefinedError
    end
  end

  context '#alias_function' do
    it 'returns nil' do
      expect(library.alias_function(:assign, :set)).to be_nil
    end

    it 'duplicates the variable block under a different name' do
      library.alias_function(:assign, :set)

      library.evaluate_function(:set, context, ['foo', 123])

      expect(context.lookup('foo')).to eq(123)
    end

    it 'raises a FunctionNotDefinedError if the source variable is not defined' do
      expect do
        library.alias_function(:fake, :something)
      end.to raise_error Cadenza::FunctionNotDefinedError
    end
  end

  context 'deprecated functions' do
    before { expect(library).to receive(:warn) }

    it 'has deprecated #functional_variables' do
      expect(library).to receive(:functions)
      library.functional_variables
    end

    it 'has deprecated #lookup_functional_variable' do
      expect(library).to receive(:lookup_function)
      library.lookup_functional_variable(:assign)
    end

    it 'has deprecated #define_functional_variable' do
      expect(library).to receive(:define_function)
      library.define_functional_variable(:zomg) {}
    end

    it 'has deprecated #alias_functional_variable' do
      expect(library).to receive(:alias_function)
      library.alias_functional_variable(:assign, :zomg)
    end

    it 'has deprecated #evaluate_functional_variable' do
      expect(library).to receive(:evaluate_function)
      library.evaluate_functional_variable(:assign, context, ['foo', 123])
    end
  end

  context 'deprecated constants' do
    it 'has deprecated FunctionalVariableNotDefinedError' do
      expect(Cadenza).to receive(:warn)
      expect(Cadenza::FunctionalVariableNotDefinedError).to eq(Cadenza::FunctionNotDefinedError)
    end
  end
end
