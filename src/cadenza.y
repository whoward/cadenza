class Cadenza::Parser
	prechigh
		left '*' '/'
		left '+' '-'

	preclow

rule

  target
  	: document
    | /* none */ { result = nil }
	;

  primary_expression
  	: IDENTIFIER                    { result = VariableNode.new(val[0], val[0]) }
  	| INTEGER                       { result = ConstantNode.new(val[0], val[0]) }
  	| REAL                          { result = ConstantNode.new(val[0], val[0]) }
  	| STRING                        { result = ConstantNode.new(val[0], val[0]) }
  	| '(' additive_expression ')'	{ result = val[1] }
	;
	
  filename
    : IDENTIFIER  { result = VariableNode.new(val[0], val[0]) }
    | STRING      { result = ConstantNode.new(val[0], val[0]) }
    ;
	
  multiplicative_expression
  	: primary_expression
  	| multiplicative_expression '*' primary_expression { result = ArithmeticNode.new(val[0],val[2],'*',val[0]) }
  	| multiplicative_expression '/' primary_expression { result = ArithmeticNode.new(val[0],val[2],'/',val[0]) }
	;
	
  additive_expression
  	: multiplicative_expression
  	| additive_expression '+' multiplicative_expression { result = ArithmeticNode.new(val[0],val[2],'+',val[0]) }
  	| additive_expression '-' multiplicative_expression { result = ArithmeticNode.new(val[0],val[2],'-',val[0]) }
  	;
  	
  boolean_expression
  	: additive_expression
  	| additive_expression OP_EQ  additive_expression	{ result = BooleanNode.new(val[0],val[2],'==',val[0]) }
  	| additive_expression OP_NEQ additive_expression	{ result = BooleanNode.new(val[0],val[2],'!=',val[0]) }
  	| additive_expression OP_GEQ additive_expression	{ result = BooleanNode.new(val[0],val[2],'>=',val[0]) }
  	| additive_expression OP_LEQ additive_expression	{ result = BooleanNode.new(val[0],val[2],'<=',val[0]) }
  	| additive_expression  '>'   additive_expression	{ result = BooleanNode.new(val[0],val[2],'<' ,val[0]) }
  	| additive_expression  '<'   additive_expression	{ result = BooleanNode.new(val[0],val[2],'>' ,val[0]) }
  	;
  	
  param_list
  	: additive_expression					{ result = [val[0]] }
  	| param_list ',' additive_expression	{ result = val[0].push(val[2]) }
  	;
  	
  mapped_param_list
  	: STRING OP_MAP boolean_expression
  		{
  			result = Hash.new
  			key = ConstantNode.new(val[0], val[0])
  			value = val[2]
  			result.store(key, value)
  		}
  	| mapped_param_list ',' STRING OP_MAP boolean_expression
  		{
  			key = ConstantNode.new(val[2], val[2])
  			value = val[4]
  			val[0].store(key, value)
  		}
  	;
  	
  filter
  	: IDENTIFIER			{ result = FilterReference.new(val[0], [])    }
  	| IDENTIFIER param_list { result = FilterReference.new(val[0], val[1]) }
  	;
  
  filter_list
  	: filter				 { result = [val[0]] }
  	| filter_list '|' filter { result = val[0].push(val[2]) }
  	;
  	
  inject_statement
  	: VAR_OPEN boolean_expression VAR_CLOSE       			 { result = InjectNode.new(val[1], [],     val[0]) }
  	| VAR_OPEN boolean_expression '|' filter_list VAR_CLOSE { result = InjectNode.new(val[1], val[3], val[0]) }
  	;

  if_statement
  	: STMT_OPEN IF boolean_expression STMT_CLOSE 
  		{
  			@document_stack.push(DocumentNode.new)
  			result = val[2]
  		}
	;
	
  if_block
   	: if_statement document STMT_OPEN ENDIF STMT_CLOSE
   		{ result = IfNode.new(val[0], @document_stack.pop.children, nil, val[0]) }
   	| if_statement document STMT_OPEN ELSE
   		{ @document_stack.push(DocumentNode.new) }
   	  STMT_CLOSE document STMT_OPEN ENDIF STMT_CLOSE
   	  	{
   	  		else_body, body = @document_stack.pop, @document_stack.pop
   	  		result = IfNode.new(val[0], body.children, else_body.children, val[0])
   	  	}
   	;
   	
  for_block
  	: STMT_OPEN FOR IDENTIFIER IN IDENTIFIER STMT_CLOSE
  		{ @document_stack.push(DocumentNode.new) } 
  	  document
  	  STMT_OPEN ENDFOR STMT_CLOSE
  		{
  			iterator = VariableNode.new(val[2], val[2])
  			iterable = VariableNode.new(val[4], val[4])
  			
  			result = ForNode.new(iterator, iterable, val[0])
  			
  			result.children = @document_stack.pop.children
  		}
  	;
  	
  block_block
  	: STMT_OPEN BLOCK IDENTIFIER STMT_CLOSE
  		{ @document_stack.push( DocumentNode.new ) }
  	  document
  	  STMT_OPEN ENDBLOCK STMT_CLOSE
  	  	{
  	  		result = BlockNode.new(val[2], val[0])
  	  		result.children = @document_stack.pop.children
  	  	}
  	;
  	
  extends_statement
  	: STMT_OPEN EXTENDS filename STMT_CLOSE { result = val[2] }
  	;
 
  render_statement
  	: STMT_OPEN RENDER filename mapped_param_list STMT_CLOSE { result = RenderNode.new(val[2], val[3], val[0]) }
  	| STMT_OPEN RENDER filename STMT_CLOSE                   { result = RenderNode.new(val[2], Hash.new, val[0]) }
  	;
  	
  document
  	: TEXT_BLOCK       { @document_stack.last.children.push( TextNode.new(val[0], val[0]) ) }
  	| inject_statement { @document_stack.last.children.push( val[0] ) }
  	| if_block         { @document_stack.last.children.push( val[0] ) }
  	| for_block        { @document_stack.last.children.push( val[0] ) }
  	| block_block
  		{
  			@document_stack.last.children.push( val[0] )
  			@document_stack.first.blocks.store( val[0].name, val[0] )
  		}
  	| extends_statement         { @document_stack.first.extends = val[0] }
  	| render_statement          { @document_stack.last.children.push( val[0] ) }
  	| document TEXT_BLOCK       { @document_stack.last.children.push( TextNode.new(val[1], val[1]) ) }
  	| document inject_statement { @document_stack.last.children.push( val[1] ) }
  	| document if_block         { @document_stack.last.children.push( val[1] ) }
  	| document for_block        { @document_stack.last.children.push( val[1] ) }
  	| document block_block
  		{
  			@document_stack.last.children.push( val[1] )
  			@document_stack.first.blocks.store( val[1].name, val[1] )
  		}
  	| document extends_statement { @document_stack.first.extends = val[0] }
  	| document render_statement  { @document_stack.last.children.push( val[1]) }
  	;
  	
end

---- header ----

# cadenza.rb : generated by racc

class FilterReference < Struct.new(:identifier, :params)
end

---- inner ----

  def initialize(*args)
	super(*args)
	@lexer = Cadenza::Lexer.new
  end

  def push_token(token)
	@q.push(token)
	puts "Lexer: Token found #{token[0].to_s}(#{token[1].to_s})" if self.log_lexer
  end
 
  def parse( str )
	@lexer.source = str
	@document_stack = [DocumentNode.new]
    do_parse
    return @document_stack.first
  end

  def next_token
    @lexer.next_token
  end

  def on_error(error_token_id, error_value, value_stack)
	msg = "parse error on #{token_to_str(error_token_id)} #{error_value}\n#{value_stack.inspect}"
	raise ParseError, msg
  end
