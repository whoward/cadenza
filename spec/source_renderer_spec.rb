require 'spec_helper'

describe Cadenza::SourceRenderer do
  let(:output) { StringIO.new }
  let(:renderer) { Cadenza::SourceRenderer.new(output, error_handler: ->(e) { raise e }) }
  let(:context)  { Cadenza::Context.new }
  let(:document) { Cadenza::DocumentNode.new }

  def render(*document_children)
    document_children.each { |node| document.children.push(node) }

    renderer.render(document, context)
    renderer.output.string
  end

  context 'state machine' do
    it 'starts in the text context' do
      expect(renderer.state).to eq(:text)
    end

    it 'raises a IllegalStateError when trying to transition to a state which is not :text, :var or :tag' do
      expect do
        renderer.state = :foo
      end.to raise_error(Cadenza::SourceRenderer::IllegalStateError)
    end

    it 'appends {{ when transitioning from :text to :var' do
      renderer.state = :var
      expect(renderer.output.string).to eq('{{ ')
      expect(renderer.state).to eq(:var)
    end

    it 'appends {% when transitioning from :text to :tag' do
      renderer.state = :tag
      expect(renderer.output.string).to eq('{% ')
      expect(renderer.state).to eq(:tag)
    end

    it 'appends }} when transitioning from :var to :text' do
      renderer.state = :var
      renderer.state = :text
      expect(renderer.output.string).to eq('{{  }}')
      expect(renderer.state).to eq(:text)
    end

    it 'appends %} when transitioning from :tag to :text' do
      renderer.state = :tag
      renderer.state = :text
      expect(renderer.output.string).to eq('{%  %}')
      expect(renderer.state).to eq(:text)
    end

    it 'raises an IllegalStateTransitionError when trying to transition from :var to :tag' do
      renderer.state = :var
      expect do
        renderer.state = :tag
      end.to raise_error(Cadenza::SourceRenderer::IllegalStateTransitionError)
    end

    it 'raises an IllegalStateTransitionError when trying to transition from :tag to :var' do
      renderer.state = :tag
      expect do
        renderer.state = :var
      end.to raise_error(Cadenza::SourceRenderer::IllegalStateTransitionError)
    end
  end

  context '#render' do
    it 'returns to the :text state if it transitions to another state while rendering' do
      expect(renderer.state).to eq(:text)
      expect(render(Cadenza::ConstantNode.new(123))).to eq('{{ 123 }}')
      expect(renderer.state).to eq(:text)
    end
  end

  context 'text nodes' do
    it 'renders text source' do
      expect(render(Cadenza::TextNode.new('abc'))).to eq('abc')
    end

    it 'transitions to the text state before rendering' do
      text = Cadenza::TextNode.new('abc')
      pi = Cadenza::VariableNode.new('pi')

      expect(render(pi, text)).to eq('{{ pi }}abc')
    end
  end

  context 'constant nodes' do
    it "renders a fixnum to it's literal value" do
      expect(render(Cadenza::ConstantNode.new(123))).to eq('{{ 123 }}')
    end

    it "renders a float to it's literal value" do
      expect(render(Cadenza::ConstantNode.new(123.45))).to eq('{{ 123.45 }}')
    end

    it "renders a string to it's literal value" do
      expect(render(Cadenza::ConstantNode.new('hello'))).to eq('{{ "hello" }}')
    end
  end

  context 'variable nodes' do
    it 'renders the identifier' do
      expect(render(Cadenza::VariableNode.new('pi'))).to eq('{{ pi }}')
    end

    it 'renders parameters to the identifier' do
      template = Cadenza::ConstantNode.new('template.cadenza')
      load = Cadenza::VariableNode.new('load', [template])

      expect(render(load)).to eq('{{ load "template.cadenza" }}')
    end

    it 'renders multiple parameters to the identifier' do
      template_a = Cadenza::ConstantNode.new('template.cadenza')
      template_b = Cadenza::ConstantNode.new('blah.cadenza')

      load = Cadenza::VariableNode.new('load', [template_a, template_b])

      expect(render(load)).to eq('{{ load "template.cadenza", "blah.cadenza" }}')
    end
  end

  context 'filtered value node' do
    it 'renders each filter separated by pipes' do
      value = Cadenza::VariableNode.new('x')
      upper = Cadenza::FilterNode.new('upper')

      filtered_node = Cadenza::FilteredValueNode.new(value, [upper])

      expect(render(filtered_node)).to eq('{{ x | upper }}')
    end

    it 'renders multiple filters' do
      value = Cadenza::VariableNode.new('x')
      upper = Cadenza::FilterNode.new('upper')
      lower = Cadenza::FilterNode.new('lower')

      filtered_node = Cadenza::FilteredValueNode.new(value, [upper, lower])

      expect(render(filtered_node)).to eq('{{ x | upper | lower }}')
    end

    it 'renders filters with parameters' do
      value = Cadenza::VariableNode.new('x')
      limit = Cadenza::FilterNode.new('limit', [Cadenza::ConstantNode.new(3)])

      filtered_node = Cadenza::FilteredValueNode.new(value, [limit])

      expect(render(filtered_node)).to eq('{{ x | limit: 3 }}')
    end

    it 'renders filters with multiple parameters' do
      value = Cadenza::VariableNode.new('x')
      range = Cadenza::FilterNode.new('in_range', [Cadenza::ConstantNode.new(3), Cadenza::ConstantNode.new(5)])

      filtered_node = Cadenza::FilteredValueNode.new(value, [range])

      expect(render(filtered_node)).to eq('{{ x | in_range: 3, 5 }}')
    end
  end

  context 'operation nodes' do
    let(:x) { Cadenza::VariableNode.new('x') }
    let(:y) { Cadenza::VariableNode.new('y') }
    let(:z) { Cadenza::VariableNode.new('z') }

    it 'renders both branches and the operator' do
      one = Cadenza::ConstantNode.new(1)
      op = Cadenza::OperationNode.new(x, '+', one)

      expect(render(op)).to eq('{{ x + 1 }}')
    end

    it 'wraps the left node in brackets if it is lower precedence' do
      brak = Cadenza::OperationNode.new(x, '+', y)
      node = Cadenza::OperationNode.new(brak, '*', z)

      expect(render(node)).to eq('{{ (x + y) * z }}')
    end

    it 'wraps the right node in brackets if it is lower precedence' do
      brak = Cadenza::OperationNode.new(y, '+', z)
      node = Cadenza::OperationNode.new(x, '*', brak)

      expect(render(node)).to eq('{{ x * (y + z) }}')
    end

    # I don't think wrapping the left subtree in brackets matters because
    # order of operations will never have this be an issue in the case of
    # equal precedence - please provide an example if you can think of one!

    it 'wraps the right node in brackets if it has equal precedence' do
      # constructing this expression tree: x * (y / z)
      rhs = Cadenza::OperationNode.new(y, '/', z)
      node = Cadenza::OperationNode.new(x, '*', rhs)

      expect(render(node)).to eq('{{ x * (y / z) }}')
    end

    it 'does not wrap the right node in brackets if it has the same operator and precedence' do
      # constructing this expression tree: x * y * z
      rhs = Cadenza::OperationNode.new(y, '*', z)
      node = Cadenza::OperationNode.new(x, '*', rhs)

      expect(render(node)).to eq('{{ x * y * z }}')
    end
  end

  context 'if nodes' do
    it "renders the wrapping tags and it's children" do
      expression = Cadenza::OperationNode.new(Cadenza::VariableNode.new('x'), '>', Cadenza::ConstantNode.new(1))
      abc = Cadenza::TextNode.new('abc')

      if_node = Cadenza::IfNode.new(expression, [abc])

      expect(render(if_node)).to eq('{% if x > 1 %}abc{% endif %}')
    end

    it 'renders the else block if there are given children' do
      expression = Cadenza::OperationNode.new(Cadenza::VariableNode.new('x'), '>', Cadenza::ConstantNode.new(1))
      abc = Cadenza::TextNode.new('abc')

      if_node = Cadenza::IfNode.new(expression, [abc])

      expect(render(if_node)).to eq('{% if x > 1 %}abc{% endif %}')
    end
  end

  context 'for nodes' do
    it "renders the wrapping tags and it's children" do
      iterator = Cadenza::VariableNode.new('item')
      iterable = Cadenza::VariableNode.new('items')
      abc = Cadenza::TextNode.new('abc')

      for_node = Cadenza::ForNode.new(iterator, iterable, [abc])

      expect(render(for_node)).to eq('{% for item in items %}abc{% endfor %}')
    end
  end

  context 'block nodes' do
    it "renders the wrapping tags and it's children" do
      block_node = Cadenza::BlockNode.new('content', [Cadenza::TextNode.new('abc')])

      expect(render(block_node)).to eq('{% block content %}abc{% endblock %}')
    end
  end

  context 'generic block nodes' do
    it "renders the wrapping tags and it's children" do
      text = Cadenza::TextNode.new('<h1>Hello World!</h1>')

      block_node = Cadenza::GenericBlockNode.new('escape', [text])

      expect(render(block_node)).to eq('{% escape %}<h1>Hello World!</h1>{% end %}')
    end

    it 'renders a parameter given' do
      text = Cadenza::TextNode.new('<h1>Hello World!</h1>')
      escape = Cadenza::VariableNode.new('escape')

      block_node = Cadenza::GenericBlockNode.new('filter', [text], [escape])

      expect(render(block_node)).to eq('{% filter escape %}<h1>Hello World!</h1>{% end %}')
    end

    it 'renders multiple parameters' do
      text = Cadenza::TextNode.new('<h1>Hello World!</h1>')
      escape = Cadenza::VariableNode.new('escape')
      upcase = Cadenza::VariableNode.new('upcase')

      block_node = Cadenza::GenericBlockNode.new('filter', [text], [escape, upcase])

      expect(render(block_node)).to eq('{% filter escape, upcase %}<h1>Hello World!</h1>{% end %}')
    end
  end

  context 'extension nodes' do
    it 'renders the extension tag' do
      document.extends = 'parent.html.cadenza'

      expect(render).to eq('{% extends "parent.html.cadenza" %}')
    end

    it 'renders the extension tag before any other children' do
      text = Cadenza::TextNode.new('abc')

      document.extends = 'parent.html.cadenza'

      expect(render(text)).to eq('{% extends "parent.html.cadenza" %}abc')
    end
  end
end
