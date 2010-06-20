require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer, 'whitespace behavior' do

  before(:all) do
    @lexer = Cadenza::Lexer.new
  end

  it "should ignore whitespace inside of inject tags" do
    @lexer.source = 'abc{{def}}ghi'
    
    first_set = @lexer.remaining_tokens
    
    @lexer.source = 'abc{{ def    }}ghi'
    
    @lexer.remaining_tokens.should == first_set
  end
  
  it "should ignore whitespace inside of inject tags with filters" do
    @lexer.source = 'abc{{def|ghi"jkl"}}mno'
    
    first_set = @lexer.remaining_tokens
    
    @lexer.source = "abc{{   def |\n     ghi \"jkl\"   }}mno"
    
    @lexer.remaining_tokens.should == first_set
  end
  
  it "should ignore whitespace inside of statement tags" do
    @lexer.source = '{%foo"bar",1+2*3,"baz"%}'
    
    first_set = @lexer.remaining_tokens
    
    @lexer.source = '{% foo "bar", 1+2*3, "baz" %}'
    
    @lexer.remaining_tokens.should == first_set
  end
  
end
