require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Node, 'implied globals list' do
  
  before do
    @node = Cadenza::Node.new(Cadenza::Token.new(3.14159, 1, 1))
  end
  
  it "should provide a method to extract implied globals from a parsed template" do
    @node.should respond_to("implied_globals")
  end
  
  it "should raise an exception since its an 'abstract' method" do
    lambda do
      @node.implied_globals
    end.should raise_error
  end
  
end

describe Cadenza::ArithmeticNode, 'implied globals list' do
  it "should return the union of its left and right node implied globals" do
    # render a bunch of simple templates, grab the arithmetic node
    # (its nested under DocumentNode > InjectNode)
    node_a = Cadenza::Parser.parse("{{ 3.14159 + foo }}").children.first.identifier
    node_b = Cadenza::Parser.parse("{{ foo + bar }}").children.first.identifier
    node_c = Cadenza::Parser.parse("{{ foo * foo }}").children.first.identifier
    
    node_a.implied_globals.should == %w(foo)
    node_b.implied_globals.should == %w(foo bar)
    node_c.implied_globals.should == %w(foo)
  end
end

describe Cadenza::BlockNode, 'implied globals list' do
  it "should return a list of its child node's implied globals" do
    node = Cadenza::Parser.parse("{% block foo %}{{ bar }}{{ baz }}{% endblock %}").children.first
    node.implied_globals.should == %w(bar baz)
  end
end

describe Cadenza::BooleanNode, 'implied globals list' do
  it "should return the union of its left and right node implied globals" do
    # render a bunch of simple templates, grab the boolean node
    # (its nested under DocumentNode > IfNode)
    node_a = Cadenza::Parser.parse("{% if foo == 3.14159 %} {% endif %}").children.first.expression
    node_b = Cadenza::Parser.parse("{% if foo == bar %} {% endif %}").children.first.expression
    node_c = Cadenza::Parser.parse("{% if foo == foo %} {% endif %}").children.first.expression
    
    node_a.implied_globals.should == %w(foo)
    node_b.implied_globals.should == %w(foo bar)
    node_c.implied_globals.should == %w(foo)    
  end  
end

describe Cadenza::ConstantNode, 'implied globals list' do
  
  it "should return an empty array - as constants have no identifiers" do
    token = Cadenza::Token.new(3.14159, 1, 1)
    node = Cadenza::ConstantNode.new(token, token)
    
    node.implied_globals.should == []
  end
  
end

describe Cadenza::DocumentNode, 'implied globals list' do
  it "should return a list of its children's implied globals and its block's implied globals" do
    node = Cadenza::Parser.parse("
      {% block foo %}
        {{bar}}
      {% endblock %}
      {{baz}}
    ")
    
    node.implied_globals.should == %w(bar baz)
  end
end

describe Cadenza::ForNode, 'implied globals list' do
  it "should return a list of its children's implied globals minus any locals defined by it, properties of the local iterator should be in dot notation of the iterable" do
    node_a = Cadenza::Parser.parse("{% for foo in bars %} {{baz}} {{waz}} {% endfor %}").children.first
    node_b = Cadenza::Parser.parse("{% for foo in bars %} {{baz}} {{foo}} {% endfor %}").children.first
    node_c = Cadenza::Parser.parse("{% for foo in bars %} {{baz}} {{forloop.counter}} {% endfor %}").children.first
    node_d = Cadenza::Parser.parse("{% for foo in bars %} {{baz}} {{forloop.counter0}} {% endfor %}").children.first
    node_e = Cadenza::Parser.parse("{% for foo in bars %} {{baz}} {{forloop.first}} {% endfor %}").children.first
    node_f = Cadenza::Parser.parse("{% for foo in bars %} {{baz}} {{forloop.last}} {% endfor %}").children.first
    node_g = Cadenza::Parser.parse("{% for foo in bars %} {{foo.baz}} {% endfor %}").children.first
    node_h = Cadenza::Parser.parse("{% for foo in bars %}{{a}}{% for baz in foo.bazs %}{{b}}{{baz.waz}}{% endfor %}{% endfor %}").children.first

    node_a.implied_globals.sort.should == %w(bars baz waz)
    node_b.implied_globals.sort.should == %w(bars baz)
    node_c.implied_globals.sort.should == %w(bars baz)
    node_d.implied_globals.sort.should == %w(bars baz)
    node_e.implied_globals.sort.should == %w(bars baz)
    node_f.implied_globals.sort.should == %w(bars baz)
    node_g.implied_globals.sort.should == %w(bars bars.baz)
    node_h.implied_globals.sort.should == %w(a b bars bars.bazs bars.bazs.waz)
  end
end

describe Cadenza::GenericStatementNode, 'implied globals list' do
  it "should return a list of all the parameters which are identifiers" do
    node_a = Cadenza::Parser.parse("{% foo bar, baz %}").children.first
    node_b = Cadenza::Parser.parse("{% foo bar, bar %}").children.first
    
    node_a.implied_globals.should == %w(bar baz)
    node_b.implied_globals.should == %w(bar)
  end
end

describe Cadenza::IfNode, 'implied globals list' do
  it "should return a list of its children's implied globals plus the implied globals of its expression" do
    node_a = Cadenza::Parser.parse("{% if foo %} {% endif %}").children.first
    node_b = Cadenza::Parser.parse("{% if foo %}{{bar}}{% endif %}").children.first
    node_c = Cadenza::Parser.parse("{% if foo %}{{bar}}{% else %}{{baz}}{% endif %}}").children.first
    node_d = Cadenza::Parser.parse("{% if foo %}{{foo}}{% else %}{{foo}}{% endif %}}").children.first
    
    node_a.implied_globals.should == %w(foo)
    node_b.implied_globals.should == %w(foo bar)
    node_c.implied_globals.should == %w(foo bar baz)
    node_d.implied_globals.should == %w(foo)
  end
end

describe Cadenza::InjectNode, 'implied globals list' do
  it "should return a list of its identifier's implied globals and the implied globals of each filter param but not the filter names" do
    node_a = Cadenza::Parser.parse("{{foo}}").children.first
    node_b = Cadenza::Parser.parse("{{foo|bar}}").children.first
    node_c = Cadenza::Parser.parse("{{foo|bar baz}}").children.first
    node_d = Cadenza::Parser.parse("{{foo|bar foo}}").children.first
    
    node_a.implied_globals.should == %w(foo)
    node_b.implied_globals.should == %w(foo)
    node_c.implied_globals.should == %w(foo baz)
    node_d.implied_globals.should == %w(foo)
  end
end

describe Cadenza::RenderNode, 'implied globals list' do
  it "should return an empty list, as renders are done dynamically" do
    token = Cadenza::Token.new("foo.cadenza", 1, 2)
    node = Cadenza::RenderNode.new("foo.cadenza", {}, token)
    
    node.implied_globals.should == []
  end
end

describe Cadenza::TextNode, 'implied globals list' do
  it "should return an empty list, as text has no identifiers" do
    token = Cadenza::Token.new("lorem ipsum", 1, 2)
    node = Cadenza::TextNode.new(token, token)
    
    node.implied_globals.should == []
  end
end

describe Cadenza::VariableNode, 'implied globals list' do
  it "should return itself wrapped in an array" do
    token = Cadenza::Token.new("foo", 1, 2)
    node = Cadenza::VariableNode.new(token, token)
    
    node.implied_globals.should == %w(foo)
  end
end
