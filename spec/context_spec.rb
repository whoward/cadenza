require 'spec_helper'
require 'ostruct'
require 'cgi'

describe Cadenza::Context do
  it 'should start with an empty stack' do
    expect(Cadenza::Context.new.stack).to eq([{}])
  end

  it 'should begin with whiny template loading disabled' do
    expect(Cadenza::Context.new.whiny_template_loading).to eq(false)
  end

  it "should take a hash and define that as the stack's first element" do
    expect(Cadenza::Context.new(foo: 'bar').stack).to eq([{ foo: 'bar' }])
  end

  it 'should allow pushing new values onto the stack' do
    context = Cadenza::Context.new(foo: 'bar')
    context.push(baz: 'foo')

    expect(context.stack).to eq([{ foo: 'bar' }, { baz: 'foo' }])
  end

  context '#clone' do
    let(:context_class) do
      klass = Class.new(Cadenza::Context)
      klass.define_filter(:upcase) { |input, _params| input.upcase }
      klass.define_function(:assign) { |context, name, value| context.assign(name, value) }
      klass
    end

    let(:context) { context_class.new(foo: 'bar') }

    before do
      context.add_loader Cadenza::FilesystemLoader.new(Fixture.filename('templates'))
    end

    it "should duplicate it's stack" do
      expect(context.clone.stack).not_to equal context.stack
      expect(context.clone.stack).to eq(context.stack)
    end

    it "should not duplicate the values of it's stack" do
      expect(context.clone.stack.first[:foo]).to equal context.stack.first[:foo]
    end

    it "should duplicate it's loader list" do
      expect(context.clone.loaders).not_to equal context.loaders
      expect(context.clone.loaders).to eq(context.loaders)
    end

    it 'should not duplicate the loaders inside the list' do
      expect(context.clone.loaders.first).to equal context.loaders.first
    end
  end

  context '#lookup' do
    let(:context_class) do
      klass = Class.new(Cadenza::Context)
      klass.define_function(:assign, &assign)
      klass
    end

    let(:scope) { { foo: { bar: 'baz' }, abc: OpenStruct.new(def: 'ghi'), alphabet: %w(a b c), obj: TestContextObject.new } }
    let(:assign) { ->(context, name, value) { context.assign(name, value) } }
    let(:context) { context_class.new(scope) }

    it 'should retrieve the value of an identifier' do
      expect(context.lookup('foo')).to eq(bar: 'baz')
    end

    it 'should retrieve the value of an identifier with dot notation' do
      expect(context.lookup('foo.bar')).to eq('baz')
    end

    it 'should retrieve the value of an identifier in a higher scope' do
      context.push(baz: 'foo')
      expect(context.lookup('baz')).to eq('foo')
    end

    it 'should retreive the overriden value of an identifier in a higher scope' do
      context.push(foo: 'baz')
      expect(context.lookup('foo')).to eq('baz')
    end

    it 'should allow popping the top scope off the stack' do
      context.push(foo: 'baz')

      expect(context.lookup('foo')).to eq('baz')

      context.pop

      expect(context.lookup('foo')).to eq(bar: 'baz')
    end

    it 'should look up array indexes' do
      expect(context.lookup('alphabet.1')).to eq('b')
    end

    it "should look up a function by it's name" do
      expect(context.lookup('assign')).to eq(assign)
    end

    it 'should look up a function instead of a variable of the same name' do
      context.push(assign: 'foo')
      expect(context.lookup('assign')).to eq(assign)
    end

    it 'calls methods on ContextObjects' do
      expect(context.lookup('obj.public_visibility_method')).to eq(123)
    end

    it "doesn't look up values on objects which are not ContextObjects" do
      expect(context.lookup('abc.def')).to eq nil
    end
  end

  context '#assign' do
    let(:context) { Cadenza::Context.new }

    it 'should assign a value to the current stack' do
      expect(context.lookup('foo')).to be_nil

      expect { context.assign(:foo, 'bar') }.not_to change(context.stack, :length)

      expect(context.lookup('foo')).to eq('bar')
    end
  end

  context 'loaders' do
    let(:context) { Cadenza::Context.new }
    let(:template_path) { Fixture.filename('templates/fake') }
    let(:filesystem_loader) { Cadenza::FilesystemLoader.new(template_path) }
    let(:template) { FixtureSyntaxTree.new('text/basic.yml').document }

    it 'should start with an empty list of loaders' do
      expect(context.loaders).to eq([])
    end

    it 'should allow adding a loader class' do
      context.add_loader filesystem_loader
      expect(context.loaders).to eq([filesystem_loader])
    end

    it 'should allow adding a load path' do
      path = Fixture.filename('foo')
      context.add_load_path(path)

      expect(context.loaders.size).to eq(1)
      expect(context.loaders[0]).to be_a Cadenza::FilesystemLoader
      expect(context.loaders[0].path).to eq(path)
    end

    it 'should return nil if no template was found' do
      context.add_loader(filesystem_loader)
      context.add_loader(Cadenza::FilesystemLoader.new(template_path))

      expect(context.load_source('fake.html')).to be_nil
      expect(context.load_template('fake.html')).to be_nil
    end

    it 'should raise an error if no template was found and whiny template loading is enabled' do
      context.whiny_template_loading = true

      expect do
        context.load_source('fake.html')
      end.to raise_error Cadenza::TemplateNotFoundError

      expect do
        context.load_template('fake.html')
      end.to raise_error Cadenza::TemplateNotFoundError
    end

    it 'should always raise the exception regardless of whiny template loading when the bang is provided' do
      expect do
        context.load_source!('fake.html')
      end.to raise_error Cadenza::TemplateNotFoundError

      expect do
        context.load_template!('fake.html')
      end.to raise_error Cadenza::TemplateNotFoundError
    end

    it 'should traverse the loaders in order to find the first loaded template' do
      other_loader = Cadenza::FilesystemLoader.new(template_path)

      context.add_loader(filesystem_loader)
      context.add_loader(other_loader)

      expect(filesystem_loader).to receive(:load_template).with('template.html').and_return(template)
      allow(other_loader).to receive(:load_template).and_return('foo')

      expect(context.load_template('template.html')).to eq(template)
    end

    it 'should provide a method to clear the loaders' do
      context.add_loader(filesystem_loader)
      expect(context.loaders).not_to be_empty
      context.clear_loaders
      expect(context.loaders).to be_empty
    end
  end
end
