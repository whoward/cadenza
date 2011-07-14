require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer, 'token parsing' do
  
  before(:all) do
    @lexer = Cadenza::Lexer.new
  end

  def tokens_for(string)
    @lexer.source = string
    @lexer.remaining_tokens.map(&:first)
  end

  it "should return a end token for an empty string" do
    tokens_for("").should == [false]
    tokens_for(nil).should == [false]
  end

  it "should parse blocks of text" do
    tokens_for("abc").should == [:TEXT_BLOCK, false]
  end

  it "should parse an opening injection token" do
    tokens_for("{{").should == [:VAR_OPEN, false]
  end

  it "should parse an ending injection token" do
    tokens_for("{{}}").should == [:VAR_OPEN, :VAR_CLOSE, false]
  end

  it "should parse an opening statement token" do
    tokens_for("{%").should == [:STMT_OPEN, false]
  end

  it "should parse an ending statement token" do
    tokens_for("{%%}").should == [:STMT_OPEN, :STMT_CLOSE, false]
  end

  it "should not parse comments" do
    tokens_for("{# hello #}").should == [false]
  end
    
  it "should parse constants" do
    tokens_for("{{3}}").should ==     [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false]
    tokens_for("{{+3}}").should ==     [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false]
    tokens_for("{{-3}}").should ==     [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false]

    tokens_for("{{3.14}}").should ==  [:VAR_OPEN, :REAL,    :VAR_CLOSE, false]
    tokens_for("{{+3.14}}").should ==  [:VAR_OPEN, :REAL,    :VAR_CLOSE, false]
    tokens_for("{{-3.14}}").should ==  [:VAR_OPEN, :REAL,    :VAR_CLOSE, false]

    tokens_for("{{'3'}}").should ==   [:VAR_OPEN, :STRING,  :VAR_CLOSE, false]
    tokens_for("{{\"3\"}}").should == [:VAR_OPEN, :STRING,  :VAR_CLOSE, false]
  end

  it "should scan identifiers" do
    tokens_for("{{foo}}").should == [:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false]
    tokens_for("{{foo.bar}}").should == [:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false]
  end

  it "should scan keywords" do
    tokens_for("{%if%}").should       == [:STMT_OPEN, :IF, :STMT_CLOSE, false]
    tokens_for("{%else%}").should     == [:STMT_OPEN, :ELSE, :STMT_CLOSE, false]
    tokens_for("{%endif%}").should    == [:STMT_OPEN, :ENDIF, :STMT_CLOSE, false]
    tokens_for("{%for%}").should      == [:STMT_OPEN, :FOR, :STMT_CLOSE, false]
    tokens_for("{%in%}").should       == [:STMT_OPEN, :IN, :STMT_CLOSE, false]
    tokens_for("{%endfor%}").should   == [:STMT_OPEN, :ENDFOR, :STMT_CLOSE, false]
    tokens_for("{%block%}").should    == [:STMT_OPEN, :BLOCK, :STMT_CLOSE, false]
    tokens_for("{%endblock%}").should == [:STMT_OPEN, :ENDBLOCK, :STMT_CLOSE, false]
    tokens_for("{%extends%}").should  == [:STMT_OPEN, :EXTENDS, :STMT_CLOSE, false]
    tokens_for("{%render%}").should   == [:STMT_OPEN, :RENDER, :STMT_CLOSE, false]
  end

  it "should ignore whitespace inside of statements" do
    tokens_for("{{ 3 }}").should == [:VAR_OPEN, :INTEGER, :VAR_CLOSE, false]
    tokens_for("{% 3.14 %}").should == [:STMT_OPEN, :REAL, :STMT_CLOSE, false]
  end
  
  it "should scan identifiers that start with keywords as identifiers" do
    tokens_for("{{ forloop }}").should == [:VAR_OPEN, :IDENTIFIER, :VAR_CLOSE, false]
  end

  it "should scan the equivalence operator" do
    tokens_for("{% == %}").should == [:STMT_OPEN, :OP_EQ, :STMT_CLOSE, false]
  end

  it "should scan the greater than or equal to operator" do
    tokens_for("{% >= %}").should == [:STMT_OPEN, :OP_GEQ, :STMT_CLOSE, false]
  end

  it "should scan the less than or equal to operator" do
    tokens_for("{% <= %}").should == [:STMT_OPEN, :OP_LEQ, :STMT_CLOSE, false]
  end

  it "should scan the hash rocket operaor" do
    tokens_for("{% => %}").should == [:STMT_OPEN, :OP_MAP, :STMT_CLOSE, false]
  end

  it "should match individual characters inside of statements" do
    tokens_for("{% if foo > 0 %}").should == [:STMT_OPEN, :IF, :IDENTIFIER, ">", :INTEGER, :STMT_CLOSE, false]
  end

end