require 'spec_helper'

describe Cadenza::TextRenderer do
  let(:context_class) do
    klass = Class.new(Cadenza::Context)

    klass.define_filter(:escape) { |input, _params| CGI.escapeHTML(input) }

    klass.define_block :filter do |context, nodes, parameters|
      filter = parameters.first.identifier

      nodes.inject('') do |output, child|
        node_text = Cadenza::TextRenderer.render(child, context)
        output << context.evaluate_filter(filter, node_text)
      end
    end

    klass.define_function(:raise) { |_context, _template| fail StandardError, 'test error' }

    klass
  end

  let(:context)  { context_class.new(pi: 3.14159, collection: %w(a b c)) }
  let(:document) { Cadenza::DocumentNode.new }

  before do
    context.add_loader Cadenza::FilesystemLoader.new(Fixture.filename('templates'))
  end

  it "should render a text node's content" do
    expect_rendering('foo', context).to eq 'foo'
  end

  it "should render a constant node's string value" do
    expect_rendering('{{ 3.14159 }}', context).to eq '3.14159'
  end

  it "should render a variable node's value based on the value in the context" do
    expect_rendering('{{ pi }}', context).to eq '3.14159'
  end

  it "should render the stringified result of an arithmetic node's value" do
    expect_rendering('{{ pi + 1 }}', context).to eq '4.14159'
  end

  it 'should render the value of a inject node to the output' do
    klass = Class.new(Cadenza::Context)
    klass.define_filter(:floor) { |value, _params| value.floor }
    klass.define_filter(:add)   { |value, params| value + params.first }

    context = klass.new(pi: 3.14159)

    expect_rendering('{{ pi | floor | add: 1 }}', context).to eq '4'
  end

  context 'if nodes' do
    let(:if_blocks_template) { Fixture.read('templates/if_node/blocks.html.cadenza') }
    let(:if_blocks_output) { Fixture.read('templates/if_node/blocks.html') }

    let(:custom_if_blocks_template) { Fixture.read('templates/if_node/custom_blocks.html.cadenza') }
    let(:custom_if_blocks_output)   { Fixture.read('templates/if_node/custom_blocks.html') }

    it "should render the stringified result of a boolean node's value" do
      expect_rendering('{{ pi > 1 }}', context).to eq 'true'
    end

    it 'should render the appropriate block of the if node' do
      expect_rendering('{% if pi > 1 %}yup{% else %}nope{% endif %}', context).to eq 'yup'
    end

    it "renders default blocks in it's child nodes" do
      expect_rendering(if_blocks_template, context).to equal_html if_blocks_output
    end

    it "renders overriden blocks in it's child nodes" do
      expect_rendering(custom_if_blocks_template, context).to equal_html custom_if_blocks_output
    end
  end

  context 'nested blocks' do
    let(:nested_block_template) { Fixture.read('templates/nested_blocks/child.html.cadenza') }
    let(:nested_block_output) { Fixture.read('templates/nested_blocks/child.html') }

    it 'renders content nested within nested layouts' do
      expect_rendering(nested_block_template, context).to equal_html nested_block_output
    end
  end

  context 'for nodes' do
    let(:standard_list_template) { Fixture.read('templates/standard_list.html.cadenza') }
    let(:standard_list_output) { Fixture.read('templates/standard_list.html') }

    let(:customized_list_template) { Fixture.read('templates/customized_list.html.cadenza') }
    let(:customized_list_output)   { Fixture.read('templates/customized_list.html') }

    it "should render a for-block's children once for each iterated object" do
      context = Cadenza::Context.new(alphabet: %w(a b c))

      expect_rendering("{% for x in alphabet %}{{ forloop.counter }}: {{ x }}\n{% endfor %}", context).to eq "1: a\n2: b\n3: c\n"
    end

    it "should render default blocks in it's children" do
      expect_rendering(standard_list_template, context).to equal_html standard_list_output
    end

    it "should render overriden blocks in it's children" do
      expect_rendering(customized_list_template, context).to equal_html customized_list_output
    end
  end

  context 'block nodes' do
    it "should render it's children if the document has no layout file" do
      expect_rendering('{% block test %}Lorem Ipsum{% endblock %}', context).to eq 'Lorem Ipsum'
    end

    it "should not render it's children if the document has a layout file" do
      template = <<-EOS
            {% extends 'empty.html.cadenza' %}
            {% block test %}Lorem Ipsum{% endblock %}
         EOS

      expect_rendering(template, context).to eq ''
    end

    it 'should render the overriden block if it is given' do
      text_a = Cadenza::TextNode.new('Hello World')
      text_b = Cadenza::TextNode.new('Lorem Ipsum')

      hello_block = Cadenza::BlockNode.new('test', [text_a])
      lorem_block = Cadenza::BlockNode.new('test', [text_b])

      document.extends = 'empty.html.cadenza'
      document.add_block(hello_block)
      document.children.push hello_block

      layout = Cadenza::DocumentNode.new
      layout.add_block(lorem_block)
      layout.children.push lorem_block

      context.stub(:load_template).and_return(layout)

      expect_rendering(document, context).to eq 'Hello World'
    end
  end

  context 'generic block nodes' do
    it "should render the text with the block's logic applied" do
      template = '{% filter escape %}<h1>Hello World!</h1>{% end %}'

      expect_rendering(template, context).to eq '&lt;h1&gt;Hello World!&lt;/h1&gt;'
    end
  end

  context 'extension nodes' do
    index = Fixture.read('templates/index.html.cadenza')
    index_output = Fixture.read('templates/index.html')

    index_two = Fixture.read('templates/index_two.html.cadenza')
    index_two_output = Fixture.read('templates/index_two.html')

    supr = Fixture.read('templates/super.html.cadenza')
    supr_output = Fixture.read('templates/super.html')

    nested_super = Fixture.read('templates/nested_blocks/super.html.cadenza')
    nested_super_output = Fixture.read('templates/nested_blocks/super.html')

    scoping = Fixture.read('templates/nested_blocks/scoping.html.cadenza')
    scoping_output = Fixture.read('templates/nested_blocks/scoping.html')

    it 'renders the extended template with the blocks from the base template' do
      expect_rendering(index, context).to equal_html index_output
    end

    it 'renders a multi level layout' do
      expect_rendering(index_two, context).to equal_html index_two_output
    end

    it 'renders multiple levels of super calls' do
      expect_rendering(supr, context).to equal_html supr_output
    end

    it 'renders super calls within blocks' do
      expect_rendering(nested_super, context).to equal_html nested_super_output
    end

    it 'renders nested blocks in a separate scope' do
      expect_rendering(scoping, context).to equal_html scoping_output
    end
  end

  context '#error_handling' do
    let(:output) { StringIO.new }
    let(:renderer) { Cadenza::TextRenderer.new(output, error_handler: ->(e) { fail e }) }
    let(:template) { Cadenza::Parser.new.parse('{{raise}}') }

    it 'returns empty data by default' do
      renderer = Cadenza::TextRenderer.new(output)
      expect_rendering(template, context, renderer: renderer).to eq ''
    end

    it 'raises an error with the :raise handler' do
      renderer = Cadenza::TextRenderer.new(output, error_handler: :raise)
      -> { renderer.render(template, context) }.should raise_error(Cadenza::RenderError)
    end

    it 'dumps the error backtrace with the :dump handler' do
      renderer = Cadenza::TextRenderer.new(output, error_handler: :dump)

      expect_rendering(template, context, renderer: renderer).to_not eq ''
    end

    it "calls the given callable object and outputs it's return value" do
      handler = ->(err) { "OH NOES! #{err.class.name}" }

      renderer = Cadenza::TextRenderer.new(output, error_handler: handler)

      expect_rendering(template, context, renderer: renderer).to eq 'OH NOES! StandardError'
    end

    it 'raises an error if the handler is something unexpected' do
      renderer = Cadenza::TextRenderer.new(output, error_handler: :wtfzzz)
      -> { renderer.render(template, context) }.should raise_error(Cadenza::Error)
    end
  end
end
