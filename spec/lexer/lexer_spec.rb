require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer do
  before(:all) do
    @lexer = Cadenza::Lexer.new
  end
  
  def all_tokens
    @lexer.remaining_tokens.map(&:first)
  end
  
  it "should scan text" do
    @lexer.source = 'abcdefghijkl'
    
    all_tokens.should == [:TEXT_BLOCK, false]
  end

  it "should ignore comments inside of text blocks" do
    @lexer.source = "abc {# some comment #} def"
    
    all_tokens.should == [:TEXT_BLOCK, :TEXT_BLOCK, false]
  end

  it "should scan inject statements" do
    @lexer.source = "abc {{ def }} ghi"
    
    all_tokens.should == [:TEXT_BLOCK, :VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, :TEXT_BLOCK, false]
  end
  
  it "should scan inject statements with filters" do
    @lexer.source = "abc {{ def | ghi 'jkl' | mno }} pqr"
    
    all_tokens.should == [:TEXT_BLOCK, :VAR_OPEN, :IDENTIFIER, '|', :IDENTIFIER, :STRING, '|', :IDENTIFIER, :VAR_CLOSE, :TEXT_BLOCK, false]
  end
  
  it "should scan statements" do
    @lexer.source = "abc {% def 'ghi' %} jkl"
    
    all_tokens.should == [:TEXT_BLOCK, :STMT_OPEN, :IDENTIFIER, :STRING, :STMT_CLOSE, :TEXT_BLOCK, false]
  end
  
  it "should scan constants inside of statements" do
    @lexer.source = "{% abc \"def\" 'ghi' 123 123.45 %}"
    
    all_tokens.should == [:STMT_OPEN, :IDENTIFIER, :STRING, :STRING, :INTEGER, :REAL, :STMT_CLOSE, false]
  end
  
  it "should scan keywords separately from identifiers inside of statements" do
    @lexer.source = "{{ if else endif for in endfor block endblock extends render }}"
    
    all_tokens.should == [:VAR_OPEN, :IF, :ELSE, :ENDIF, :FOR, :IN, :ENDFOR, :BLOCK, :ENDBLOCK, :EXTENDS, :RENDER, :VAR_CLOSE, false]
  end
  
  it "should scan identifiers that start with keywords as identifiers" do
    @lexer.source = "{{ forloop }}"
    
    all_tokens.should == [:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false]
  end
end