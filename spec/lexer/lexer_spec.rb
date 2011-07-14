require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer do
  before(:all) do
    @lexer = Cadenza::Lexer.new
  end

  def token_values(source)
    @lexer.source = source
    @lexer.remaining_tokens.map(&:last).map {|x| x == false ? x : x.value }
  end

  it "should report the counter position at (0, 0) until the parser is given something to parse" do
    @lexer.position.should == [0, 0]
  end

  it "should not raise an error if nil is passed as the data" do
    lambda do
      @lexer.source = nil
    end.should_not raise_error
  end

  it "should assign a integer value of an integer constant token" do
    token_values("{{ 123 }}").should == ["{{", 123, "}}", false]
  end

  it "should assign a real value of a real constant token" do
    token_values("{{ 123.45 }}").should == ["{{", 123.45, "}}", false]
  end
  
  it "should assign a string value of a string constant token" do
    token_values("{{ 'foo' }}").should == ["{{", "foo", "}}", false]
    token_values("{{ \"foo\" }}").should == ["{{", "foo", "}}", false]
  end

  it "should assign a identifier's name as the value of an identifier token" do
    token_values("{{ foo.bar }}").should == ["{{", "foo.bar", "}}", false]
  end

end