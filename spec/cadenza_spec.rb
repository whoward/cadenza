require 'spec_helper'

describe Cadenza do
  let(:context) { Cadenza::BaseContext.new }

  before do
    context.add_loader Cadenza::FilesystemLoader.new(Fixture.filename('templates'))
  end

  it 'should define a simple render function which will use the base context to render a string' do
    template = Fixture.read('templates/index.html.cadenza')
    expected = Fixture.read('templates/index.html')

    expect(Cadenza.render(template, {}, context: context)).to equal_html expected
  end

  it 'should allow passing a scope' do
    template = Fixture.read('templates/test.html.cadenza')

    expect(Cadenza.render(template, { pi: 3.14159 }, context: context)).to eq('abc3.14159ghi')
    expect(Cadenza.render(template, { pi: 'def' }, context: context)).to eq('abcdefghi')
  end

  it "should define a render function to load a template off the context's load system and render a string" do
    expected = Fixture.read('templates/index.html')

    expect(Cadenza.render_template('index.html.cadenza', {}, context: context)).to equal_html expected
  end

  it 'should allow passing a scope' do
    expect(Cadenza.render_template('test.html.cadenza', { pi: 3.14159 }, context: context)).to eq('abc3.14159ghi')
    expect(Cadenza.render_template('test.html.cadenza', { pi: 'foo' }, context: context)).to eq('abcfooghi')
  end
end
