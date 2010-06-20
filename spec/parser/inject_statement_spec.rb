require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'inject statements' do
  before(:all) do
    @parser = Cadenza::Parser.new
  end
  
  it "should parse an inject statement" do
    node = @parser.parse('{{somevar}}')
    
    node.children.length.should == 1
    
    inject_node = node.children.first
    
    inject_node.class.should == Cadenza::InjectNode
    inject_node.filters.should be_empty
    
    identifier = inject_node.identifier
    
    identifier.class.should == Cadenza::VariableNode
    identifier.identifier.should == "somevar"
  end
  
  it "should parse an inject statement with one filter" do
    node = @parser.parse('{{somevar | somefilter }}')
    
    filter = node.children.first.filters.first
    
    filter.identifier.value.should == "somefilter"
    filter.params.should be_empty
  end

  it "should parse an inject statement with one filter and one param" do
    node = @parser.parse('{{somevar | somefilter "abc" }}')
    
    filter = node.children.first.filters.first
    
    filter.identifier.value.should == "somefilter"
    
    filter.params.length.should == 1
    
    first_param = filter.params.first
    first_param.class.should == Cadenza::ConstantNode
    first_param.value.should == "abc"
  end
  
  it "should parse an inject statement with one filter and multiple params" do
    node = @parser.parse('{{somevar | somefilter "abc", 123.45 }}')
    
    filter = node.children.first.filters.first
    
    filter.identifier.value.should == "somefilter"
    
    filter.params.length.should == 2
    
    first_param, second_param = filter.params
    
    first_param.class.should == Cadenza::ConstantNode
    first_param.value.should == "abc"
    
    second_param.class.should == Cadenza::ConstantNode
    second_param.value.should == 123.45
  end
  
  it "should parse an inject statement with multiple filters" do
    node = @parser.parse('{{somevar | first_filter "abc" | second_filter }}')
    
    node.children.first.filters.length.should == 2
    
    first_filter, second_filter = node.children.first.filters
    
    first_filter.identifier.value.should  == "first_filter"
    second_filter.identifier.value.should == "second_filter"
    
    first_filter.params.length.should  == 1
    second_filter.params.length.should == 0
  end
end
