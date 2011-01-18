require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer, 'token parsing' do
  
  before(:all) do
    @lexer = Cadenza::Lexer.new
  end
  
  def tokens_for(string)
    @lexer.source = string
    @lexer.remaining_tokens.map(&:first)
  end
  
  it "should parse the inject tokens" do
    tokens_for("{{ }}").should == [:VAR_OPEN, :VAR_CLOSE, false]
  end
  
  it "should parse the statement tokens" do
    tokens_for("{% %}").should == [:STMT_OPEN, :STMT_CLOSE, false]
  end
  
  it "should parse text blocks" do
    tokens_for("abcdef").should == [:TEXT_BLOCK, false]
  end
  
  it "should parse constants" do
    tokens_for("{{ 3 }}").should ==     [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false]
    tokens_for("{{ 3.14 }}").should ==  [:VAR_OPEN, :REAL,    :VAR_CLOSE, false]
    tokens_for("{{ '3' }}").should ==   [:VAR_OPEN, :STRING,  :VAR_CLOSE, false]
    tokens_for("{{ \"3\" }}").should == [:VAR_OPEN, :STRING,  :VAR_CLOSE, false]
  end
  
end