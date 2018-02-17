# frozen_string_literal: true

require 'spec_helper'

describe Cadenza::StandardLibrary::Filters do
  subject { Cadenza::StandardLibrary }

  context 'addslashes' do
    it 'should replace slashes with double slashes' do
      expect(subject.evaluate_filter(:addslashes, 'foo\\bar')).to eq('foo\\\\bar')
    end

    it 'should escape single quotes' do
      expect(subject.evaluate_filter(:addslashes, "I'm here")).to eq("I\\'m here")
    end

    it 'should escape double quotes' do
      expect(subject.evaluate_filter(:addslashes, 'he said "hello world!"')).to eq('he said \\"hello world!\\"')
    end

    it 'raises an error if there are any arguments passed' do
      expect do
        subject.evaluate_filter(:addslashes, 'foo', ['x'])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'capitalize' do
    it 'should define the capitalize filter' do
      expect(subject.evaluate_filter(:capitalize, 'foo')).to eq('Foo')
    end

    it 'raises an error if there are any arguments passed' do
      expect do
        subject.evaluate_filter(:capitalize, 'foo', ['x'])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'center' do
    it 'should center the text with spaces' do
      expect(subject.evaluate_filter(:center, 'foo', [9])).to eq('   foo   ')
    end

    it 'should have an optional argument for the padding character' do
      expect(subject.evaluate_filter(:center, 'foo', [9, 'x'])).to eq('xxxfooxxx')
    end

    it 'raises an error if there are no arguments passed' do
      expect do
        subject.evaluate_filter(:center, 'foo', [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if there are more than 2 arguments passed' do
      expect do
        subject.evaluate_filter(:center, 'foo', [1, 'y', 'z'])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a fixnum' do
      expect do
        subject.evaluate_filter(:center, 'foo', ['foo'])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end

    it 'raises an error if the second argument is not a string' do
      expect do
        subject.evaluate_filter(:center, 'foo', [1, 2])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'cut' do
    it 'should remove the string from the string' do
      expect(subject.evaluate_filter(:cut, 'abcdefghi', ['def'])).to eq('abcghi')
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_filter(:cut, 'foo', [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a string' do
      expect do
        subject.evaluate_filter(:cut, 'foo', [123])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'date' do
    let(:time) { Time.at(0).utc }

    it 'should format the date using sprintf notation' do
      expect(subject.evaluate_filter(:date, time)).to eq('1970-01-01')
    end

    it 'should allow passing a custom string fomrmatting time' do
      expect(subject.evaluate_filter(:date, time, ['%F %R'])).to eq('1970-01-01 00:00')
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_filter(:date, time, %w[foo bar])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a string' do
      expect do
        subject.evaluate_filter(:date, time, [123])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'default' do
    it 'should return the value if the value is some object' do
      expect(subject.evaluate_filter(:default, 'foo', ['default'])).to eq('foo')
    end

    it 'should return the default value if the value is nil' do
      expect(subject.evaluate_filter(:default, nil, ['default'])).to eq('default')
    end

    it 'should return the default value if the value is an empty string' do
      expect(subject.evaluate_filter(:default, '', ['default'])).to eq('default')
    end

    it 'should return the default value if the value is an empty array' do
      expect(subject.evaluate_filter(:default, [], ['default'])).to eq('default')
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_filter(:default, 'foo', [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'escape' do
    it 'should convert < and > to &lt; and &gt;' do
      expect(subject.evaluate_filter(:escape, '<br>')).to eq('&lt;br&gt;')
    end

    it 'should convert & to &amp;' do
      expect(subject.evaluate_filter(:escape, 'foo & bar')).to eq('foo &amp; bar')
    end

    it 'raises an error if there are any arguments' do
      expect do
        subject.evaluate_filter(:escape, 'foo', [123])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'first' do
    it 'should return the first element of an iterable' do
      expect(subject.evaluate_filter(:first, 'abc')).to eq('a')
      expect(subject.evaluate_filter(:first, %w[def ghi jkl])).to eq('def')
    end

    it 'raises an error if there are any arguments' do
      expect do
        subject.evaluate_filter(:first, 'foo', [123])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'last' do
    it 'should return the last element of an iterable' do
      expect(subject.evaluate_filter(:last, 'abc')).to eq('c')
      expect(subject.evaluate_filter(:last, %w[def ghi jkl])).to eq('jkl')
    end

    it 'raises an error if there are any arguments' do
      expect do
        subject.evaluate_filter(:last, 'foo', [123])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'join' do
    it 'should return a string glued with the specified glue' do
      expect(subject.evaluate_filter(:join, [1, 2, 3], [', '])).to eq('1, 2, 3')
    end

    it 'uses no glue string if none is provided' do
      expect(subject.evaluate_filter(:join, [1, 2, 3], [])).to eq('123')
    end

    it 'raises an error of more than 1 argument is given' do
      expect do
        subject.evaluate_filter(:join, [1, 2, 3], %w[abc def])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a string' do
      expect do
        subject.evaluate_filter(:join, [1, 2, 3], [123])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'length' do
    it 'should return the length of the object' do
      expect(subject.evaluate_filter(:length, 'abc')).to eq(3)
      expect(subject.evaluate_filter(:length, %w[a b c d e f])).to eq(6)
    end

    it 'raises an error if any arguments are given' do
      expect do
        subject.evaluate_filter(:length, [1, 2, 3], [123])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'ljust' do
    it 'should return the string left justified by the given length' do
      expect(subject.evaluate_filter(:ljust, 'abc', [10])).to eq('abc       ')
    end

    it 'should allow passing in a padding character' do
      expect(subject.evaluate_filter(:ljust, 'abc', [10, 'x'])).to eq('abcxxxxxxx')
    end

    it 'raises an error if 0 arguments are given' do
      expect do
        subject.evaluate_filter(:ljust, 'abc', [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error of more than 2 arguments is given' do
      expect do
        subject.evaluate_filter(:ljust, 'abc', [10, 'abc', 'def'])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a fixnum' do
      expect do
        subject.evaluate_filter(:ljust, 'abc', ['def'])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end

    it 'raises an error if the second argument is not a string' do
      expect do
        subject.evaluate_filter(:ljust, 'abc', [10, 10])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'rjust' do
    it 'should return the string right justified by the given length' do
      expect(subject.evaluate_filter(:rjust, 'abc', [10])).to eq('       abc')
    end

    it 'should allow passing in a padding character' do
      expect(subject.evaluate_filter(:rjust, 'abc', [10, 'x'])).to eq('xxxxxxxabc')
    end

    it 'raises an error if 0 arguments are given' do
      expect do
        subject.evaluate_filter(:rjust, 'abc', [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error of more than 2 arguments is given' do
      expect do
        subject.evaluate_filter(:rjust, 'abc', [10, 'abc', 'def'])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a fixnum' do
      expect do
        subject.evaluate_filter(:rjust, 'abc', ['def'])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end

    it 'raises an error if the second argument is not a string' do
      expect do
        subject.evaluate_filter(:rjust, 'abc', [10, 10])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'lower' do
    it 'should downcase all characters' do
      expect(subject.evaluate_filter(:lower, 'AbC')).to eq('abc')
    end

    it 'raises an error if any arguments are given' do
      expect do
        subject.evaluate_filter(:lower, 'ABC', [123])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'upper' do
    it 'should upcase all characters' do
      expect(subject.evaluate_filter(:upper, 'abc')).to eq('ABC')
    end

    it 'raises an error if any arguments are given' do
      expect do
        subject.evaluate_filter(:upper, 'abc', [123])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'wordwrap' do
    it 'should return the string with the words wrapped at the given column' do
      wrapped = subject.evaluate_filter(:wordwrap, 'This text is not too short to be wrapped.', [20])

      expect(wrapped).to eq("This text is not too\nshort to be wrapped.")
    end

    it 'should allow specifying the character(s) used for line endings' do
      wrapped = subject.evaluate_filter(:wordwrap, 'This text is not too short to be wrapped.', [20, '<br/>'])

      expect(wrapped).to eq('This text is not too<br/>short to be wrapped.')
    end

    it 'raises an error if 0 arguments are given' do
      expect do
        subject.evaluate_filter(:wordwrap, 'abc', [])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error of more than 2 arguments is given' do
      expect do
        subject.evaluate_filter(:wordwrap, 'abc', [10, 'abc', 'def'])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a fixnum' do
      expect do
        subject.evaluate_filter(:wordwrap, 'abc', ['def'])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end

    it 'raises an error if the second argument is not a string' do
      expect do
        subject.evaluate_filter(:wordwrap, 'abc', [10, 10])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'reverse' do
    it 'returns a string in reverse form' do
      expect(subject.evaluate_filter(:reverse, 'hello')).to eq('olleh')
    end

    it 'returns an array in reverse form' do
      expect(subject.evaluate_filter(:reverse, [1, 2, 3])).to eq([3, 2, 1])
    end

    it 'raises an error if any arguments are given' do
      expect do
        subject.evaluate_filter(:reverse, 'abc', [123])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end
  end

  context 'limit' do
    it 'returns an array with the first N items' do
      expect(subject.evaluate_filter(:limit, %w[a b c], [2])).to eq(%w[a b])
    end

    it 'returns a string with the first N characters' do
      expect(subject.evaluate_filter(:limit, 'hello', [2])).to eq('he')
    end

    it 'returns an empty array if given an array and a length < 1' do
      expect(subject.evaluate_filter(:limit, %w[a b c], [0])).to eq([])
    end

    it 'returns an empty string if given a string and a length < 1' do
      expect(subject.evaluate_filter(:limit, 'hello', [0])).to eq('')
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_filter(:limit, %w[a b c], [1, 2])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a fixnum' do
      expect do
        subject.evaluate_filter(:limit, 'abc', ['def'])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'offset' do
    it 'returns an array with the elements after the Nth item (1-based)' do
      expect(subject.evaluate_filter(:offset, %w[a b c], [2])).to eq(%w[c])
    end

    it 'returns a string with the characters after the Nth character (1-based)' do
      expect(subject.evaluate_filter(:offset, 'hello', [2])).to eq('llo')
    end

    it 'returns an empty array if given an array and a N > length' do
      expect(subject.evaluate_filter(:offset, %w[a b c], [3])).to eq([])
    end

    it 'returns an empty string if given a string and a N > length' do
      expect(subject.evaluate_filter(:offset, 'hello', [5])).to eq('')
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_filter(:offset, %w[a b c], [1, 2])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a fixnum' do
      expect do
        subject.evaluate_filter(:offset, 'abc', ['def'])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'pluck' do
    let(:objects) { [{ name: 'Mike' }, { name: 'Will' }, { name: 'Dave' }] }

    it 'returns an array with the collected property passed' do
      expect(subject.evaluate_filter(:pluck, objects, ['name'])).to eq(%w[Mike Will Dave])
    end

    it 'is also aliased as map and collect' do
      expect(subject.evaluate_filter(:map, objects, ['name'])).to eq(%w[Mike Will Dave])
      expect(subject.evaluate_filter(:collect, objects, ['name'])).to eq(%w[Mike Will Dave])
    end

    it 'raises an error if there is not exactly 1 argument' do
      expect do
        subject.evaluate_filter(:pluck, objects, [1, 2])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a string' do
      expect do
        subject.evaluate_filter(:pluck, objects, [123])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end

  context 'sort' do
    let(:objects) { [{ name: 'Mike' }, { name: 'Will' }, { name: 'Dave' }] }

    it 'returns an array with the items sorted in ascending order' do
      expect(subject.evaluate_filter(:sort, %w[b c a])).to eq(%w[a b c])
    end

    it 'returns an array with the items sorted in ascending order by a given property' do
      expect(subject.evaluate_filter(:sort, objects, ['name'])).to eq(objects.sort_by { |a| a[:name] })
    end

    it 'raises an error of more than 1 argument is given' do
      expect do
        subject.evaluate_filter(:sort, objects, %w[name def])
      end.to raise_error Cadenza::InvalidArgumentCountError
    end

    it 'raises an error if the first argument is not a string' do
      expect do
        subject.evaluate_filter(:sort, objects, [123])
      end.to raise_error Cadenza::InvalidArgumentTypeError
    end
  end
end
