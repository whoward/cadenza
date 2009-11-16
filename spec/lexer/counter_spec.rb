require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Lexer do
  
  before(:all) do
    @lexer = Cadenza::Lexer.new
  end
  
  after(:each) do
    # At the end of each run we should not have any more tokens in the stream
    @lexer.next_token.should eql([false, false])
  end
  
  it "should start on column one, line one" do
    @lexer.source = ''
    
    @lexer.column.should eql(1)
    @lexer.line.should   eql(1)
  end
  
  it "should reset the counters after the source has changed" do
    @lexer.source = 'abc{{def}}'
    
    # pull out a token to advance the counter
    @lexer.next_token
    [@lexer.column, @lexer.line].should eql([4,1])
    
    # Now change the source, we should see the counter reset
    @lexer.source = 'def'
    [@lexer.column, @lexer.line].should eql([1,1])
    
    @lexer.next_token
  end
  
  it "should count columns on each token, incrementing the column AFTER the token has been created" do
    @lexer.source = 'abc{{ def }}ghi'

    # Should receive a TEXT token next
    type, token = @lexer.next_token
    
    token.column.should  eql(1)
    @lexer.column.should eql(4)
    
    # Should receive a variable opening token next
    type, token = @lexer.next_token
    
    token.column.should  eql(4)
    @lexer.column.should eql(6)

    # Should receive an identifier token next 
    type, token = @lexer.next_token
    
    token.column.should  eql(7)
    @lexer.column.should eql(10)
    
    # And then a variable closing token
    type, token = @lexer.next_token
    
    token.column.should  eql(11)
    @lexer.column.should eql(13)
    
    # Finishing with the TEXT token
    type, token = @lexer.next_token
    
    token.column.should  eql(13)
    @lexer.column.should eql(16)
  end
  
  it "should count lines, resetting the column counter each time" do
    # inside the text context it should do this
    @lexer.source = "abc def\nghi{{"
    
    # Start with a TEXT token
    type, token = @lexer.next_token
    
    [token.column, token.line].should   eql([1, 1]) 
    [@lexer.column, @lexer.line].should eql([4, 2])
    
    # End off with a variable opening token
    type, token = @lexer.next_token

    [token.column, token.line].should   eql([4, 2]) 
    [@lexer.column, @lexer.line].should eql([6, 2])    
    
    # inside the tag context it should also do this
    @lexer.source = "{{ abc\n }}"
    
    # var_open
    type, token = @lexer.next_token
    
    [token.column, token.line].should   eql([1, 1]) 
    [@lexer.column, @lexer.line].should eql([3, 1])
    
    # identifier
    type, token = @lexer.next_token
    
    [token.column, token.line].should   eql([4, 1]) 
    [@lexer.column, @lexer.line].should eql([7, 1])

    # var_close
    type, token = @lexer.next_token
    
    [token.column, token.line].should   eql([2, 2]) 
    [@lexer.column, @lexer.line].should eql([4, 2])
  end
end