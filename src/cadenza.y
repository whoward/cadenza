class Cadenza::Parser

rule
  target
    : document
    | /* none */ { result = nil }
    ;

  primary_expression
    : IDENTIFIER { result = VariableNode.new(val[0].value) }
    | INTEGER    { result = ConstantNode.new(val[0].value) }
    | REAL       { result = ConstantNode.new(val[0].value) }
    | STRING     { result = ConstantNode.new(val[0].value) }
    | '(' boolean_expression ')'  { result = val[1] }
    ;

  multiplicative_expression
    : primary_expression
    | multiplicative_expression '*' primary_expression { result = ArithmeticNode.new(val[0], "*", val[2]) }
    | multiplicative_expression '/' primary_expression { result = ArithmeticNode.new(val[0], "/", val[2]) }
    ;

  additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression { result = ArithmeticNode.new(val[0], "+", val[2]) }
    | additive_expression '-' multiplicative_expression { result = ArithmeticNode.new(val[0], "-", val[2]) }
    ;

  boolean_expression
    : additive_expression
    | boolean_expression OP_EQ additive_expression { result = BooleanNode.new(val[0], "==", val[2]) }
    | boolean_expression OP_NEQ additive_expression { result = BooleanNode.new(val[0], "!=", val[2]) }
    | boolean_expression OP_LEQ additive_expression { result = BooleanNode.new(val[0], "<=", val[2]) }
    | boolean_expression OP_GEQ additive_expression { result = BooleanNode.new(val[0], ">=", val[2]) }
    | boolean_expression '>' additive_expression  { result = BooleanNode.new(val[0], ">", val[2]) }
    | boolean_expression '<' additive_expression  { result = BooleanNode.new(val[0], "<", val[2]) }
    ;

  parameter_list
    : boolean_expression                     { result = [val[0]] }
    | parameter_list ',' boolean_expression  { result = val[0].push(val[2]) }
    ;

  filter
    : IDENTIFIER                    { result = FilterNode.new(val[0].value) }
    | IDENTIFIER ':' parameter_list { result = FilterNode.new(val[0].value, val[2]) }
    ;

  filter_list
    : filter { result = [val[0]] }
    | filter_list '|' filter { result = val[0].push(val[2]) }
    ;

  inject_statement
    : VAR_OPEN boolean_expression VAR_CLOSE
      { result = InjectNode.new(val[1]) }
    | VAR_OPEN boolean_expression '|' filter_list VAR_CLOSE
      { result = InjectNode.new(val[1], val[3]) }
    | VAR_OPEN IDENTIFIER parameter_list VAR_CLOSE 
      {
        variable = VariableNode.new(val[1].value)
        result = InjectNode.new(variable, [], val[2])
      }
    | VAR_OPEN IDENTIFIER parameter_list '|' filter_list VAR_CLOSE
      {
        variable = VariableNode.new(val[1].value)
        result = InjectNode.new(variable, val[4], val[2])
      }
    ;

  if_statement
    : STMT_OPEN IF boolean_expression STMT_CLOSE
      {
        @stack.push DocumentNode.new
        result = val[2]
      }
    ;

  if_block
    : if_statement document STMT_OPEN ENDIF STMT_CLOSE
      { 
        result = IfNode.new(val[0], @stack.pop.children)
      }
    | if_statement document STMT_OPEN ELSE
      { @stack.push DocumentNode.new }
      STMT_CLOSE document STMT_OPEN ENDIF STMT_CLOSE
      {
        false_children, true_children = @stack.pop.children, @stack.pop.children
        result = IfNode.new(val[0], true_children, false_children)
      }
    ;

  for_block
    : STMT_OPEN FOR IDENTIFIER IN IDENTIFIER STMT_CLOSE
      { @stack.push DocumentNode.new } 
      document
      STMT_OPEN ENDFOR STMT_CLOSE
      {
        iterator = VariableNode.new(val[2].value)
        iterable = VariableNode.new(val[4].value)
        
        result = ForNode.new(iterator, iterable, @stack.pop.children)
      }
    ;

  block_block
    : STMT_OPEN BLOCK IDENTIFIER STMT_CLOSE
      { @stack.push DocumentNode.new }
      document
      STMT_OPEN ENDBLOCK STMT_CLOSE
      { result = BlockNode.new(val[2].value, @stack.pop.children) }
    ;

  generic_block
    : STMT_OPEN IDENTIFIER STMT_CLOSE { @stack.push DocumentNode.new }
      document 
      STMT_OPEN END STMT_CLOSE { result = GenericBlockNode.new(val[1].value, @stack.pop.children) }
    | STMT_OPEN IDENTIFIER parameter_list STMT_CLOSE  { @stack.push DocumentNode.new }
      document 
      STMT_OPEN END STMT_CLOSE { result = GenericBlockNode.new(val[1].value, @stack.pop.children, val[2]) }
    ;

  extends_statement
    : STMT_OPEN EXTENDS STRING STMT_CLOSE { result = val[2].value }
    | STMT_OPEN EXTENDS IDENTIFIER STMT_CLOSE { result = VariableNode.new(val[2].value) }
    ;

  document_component
    : TEXT_BLOCK { result = TextNode.new(val[0].value) }
    | inject_statement
    | if_block
    | for_block
    | generic_block
    ;

  document
    : document_component { push_child val[0] }
    | document document_component { push_child val[1] }
    | extends_statement  { @stack.first.extends = val[0] }
    | document extends_statement { @stack.first.extends = val[1] }
    | block_block { push_block(val[0]) }
    | document block_block { push_block(val[1]) }
    ;

---- header ----
# parser.rb : generated by racc
  
---- inner ----
attr_reader :lexer, :container_name

def initialize(options={})
  @lexer = options.fetch(:lexer, Cadenza::Lexer.new)

  raise "Lexers passed to the parser must define next_token" unless @lexer.respond_to?(:next_token)

  raise "Lexers passed to the parser must define source=" unless @lexer.respond_to?(:source=)
end

def parse(source)
  @lexer.source = source

  @stack = [DocumentNode.new]

  do_parse

  @stack.first
end

def push_child(node)
  @stack.last.children.push(node)
end

def push_block(block_node)
  @stack.first.add_block(block_node)
  push_child(block_node)
end

def next_token
  @lexer.next_token
end