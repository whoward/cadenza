# frozen_string_literal: true

require 'spec_helper'

describe Cadenza::Library do
  subject { Cadenza::Library }

  let(:library) do
    mod = Module.new
    mod.extend(subject)
    mod
  end

  let(:standard_library) do
    subject.build do
      define_filter(:foo) {}
      define_block(:foo) {}
      define_function(:foo) {}
    end
  end

  context 'extension' do
    it 'extends the module with Cadenza::Library::Filters' do
      expect(library).to be_a Cadenza::Library::Filters
    end

    it 'extends the module with Cadenza::Library::Blocks' do
      expect(library).to be_a Cadenza::Library::Blocks
    end

    it 'extends the module with Cadenza::Library::FunctionalVariables' do
      expect(library).to be_a Cadenza::Library::Functions
    end
  end

  context 'inclusion' do
    it 'copies all defined filters into the included class' do
      expect(library.filters.size).to eq(0)
      library.send(:include, standard_library)
      expect(library.filters.size).to eq(1)
    end

    it 'copies all defined blocks into the included class' do
      expect(library.blocks.size).to eq(0)
      library.send(:include, standard_library)
      expect(library.blocks.size).to eq(1)
    end

    it 'copies all defined functions into the included class' do
      expect(library.functions.size).to eq(0)
      library.send(:include, standard_library)
      expect(library.functions.size).to eq(1)
    end
  end

  context 'inheritance' do
    let(:superclass) do
      klass = Class.new
      klass.extend(subject)
      klass.send(:include, standard_library)
      klass.define_filter(:bar) {}
      klass.define_block(:bar) {}
      klass.define_function(:bar) {}
      klass
    end

    let(:subclass) { Class.new(superclass) }

    it 'has all the filters the superclass does' do
      expect(subclass.filters.size).to eq(2)
    end

    it 'has all the blocks the superclass does' do
      expect(subclass.blocks.size).to eq(2)
    end

    it 'has all the functions the superclass does' do
      expect(subclass.functions.size).to eq(2)
    end
  end

  context '#build' do
    it 'returns a new module' do
      expect(subject.build).to be_an_instance_of Module
    end

    it 'extends the returned module by Library' do
      expect(subject.build).to be_a Cadenza::Library
    end

    it 'defines #enhance on the returned module' do
      expect(subject.build).to respond_to :enhance
    end

    it "calls a passed block on it's own instance" do
      lib = subject.build do
        define_filter(:foo) {}
      end

      expect(lib.filters[:foo]).not_to be_nil
    end

    it 'copies all filters, blocks and variables when enhancing an existing library' do
      extra_standard_library = standard_library.enhance do
        define_filter(:bar) {}
        define_block(:bar) {}
        define_function(:bar) {}
      end

      expect(extra_standard_library.filters.size).to eq(2)
      expect(extra_standard_library.blocks.size).to eq(2)
      expect(extra_standard_library.functions.size).to eq(2)
    end
  end
end
