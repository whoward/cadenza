# frozen_string_literal: true

require 'spec_helper'

describe Cadenza::Library::Filters do
  let(:library) do
    Cadenza::Library.build do
      define_filter(:pluralize) { |input, _params| "#{input}s" }
    end
  end

  context '#define_filter' do
    it 'should allow defining a filter method' do
      expect(library.filters[:pluralize]).to be_a(Proc)
    end

    it 'should evaluate a filter' do
      expect(library.evaluate_filter(:pluralize, 'bar')).to eq('bars')
    end

    it 'should raise a FilterNotDefinedError if the filter is not defined' do
      expect do
        library.evaluate_filter(:foo, 'bar')
      end.to raise_error Cadenza::FilterNotDefinedError
    end
  end

  context '#lookup_filter' do
    it 'returns the given filter' do
      expect(library.lookup_filter(:pluralize)).to be_a Proc
    end

    it 'raises a FilterNotDefinedError if the block is not defined' do
      expect do
        library.lookup_filter(:fake)
      end.to raise_error Cadenza::FilterNotDefinedError
    end
  end

  context '#alias_filter' do
    it 'returns nil' do
      expect(library.alias_filter(:pluralize, :pluralizar)).to be_nil
    end

    it 'duplicates the filter block under a different name' do
      library.alias_filter(:pluralize, :pluralizar) # alias it as the spanish form of pluralize

      expect(library.evaluate_filter(:pluralizar, 'bar')).to eq('bars')
    end

    it 'raises a FilterNotDefinedError if the source filter is not defined' do
      expect do
        library.alias_filter(:fake, :something)
      end.to raise_error Cadenza::FilterNotDefinedError
    end
  end
end
