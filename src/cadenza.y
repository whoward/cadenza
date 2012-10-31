class Cadenza::RaccParser

/* expect this many shift/reduce conflicts */
expect 39

rule
  target
    : document
    | /* none */ { result = nil }
    ;

  parameter_list
    : logical_expression                     { result = [val[0]] }
    | parameter_list ',' logical_expression  { result = val[0].push(val[2]) }
    ;

  /* this has a shift/reduce conflict but since Racc will shift in this case it is the correct behavior */
  primary_expression
    : IDENTIFIER                   { result = VariableNode.new(val[0].value) }
    | IDENTIFIER parameter_list    { result = VariableNode.new(val[0].value, val[1]) }
    | INTEGER                      { result = ConstantNode.new(val[0].value) }
    | REAL                         { result = ConstantNode.new(val[0].value) }
    | STRING                       { result = ConstantNode.new(val[0].value) }
    | '(' filtered_expression ')'   { result = val[1] }
    ;

  multiplicative_expression
    : primary_expression
    | multiplicative_expression '*' primary_expression { result = OperationNode.new(val[0], "*", val[2]) }
    | multiplicative_expression '/' primary_expression { result = OperationNode.new(val[0], "/", val[2]) }
    ;

  additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression { result = OperationNode.new(val[0], "+", val[2]) }
    | additive_expression '-' multiplicative_expression { result = OperationNode.new(val[0], "-", val[2]) }
    ;

  boolean_expression
    : additive_expression
    | boolean_expression OP_EQ additive_expression { result = OperationNode.new(val[0], "==", val[2]) }
    | boolean_expression OP_NEQ additive_expression { result = OperationNode.new(val[0], "!=", val[2]) }
    | boolean_expression OP_LEQ additive_expression { result = OperationNode.new(val[0], "<=", val[2]) }
    | boolean_expression OP_GEQ additive_expression { result = OperationNode.new(val[0], ">=", val[2]) }
    | boolean_expression '>' additive_expression  { result = OperationNode.new(val[0], ">", val[2]) }
    | boolean_expression '<' additive_expression  { result = OperationNode.new(val[0], "<", val[2]) }
    ;

  inverse_expression
    : boolean_expression
    | NOT boolean_expression { result = BooleanInverseNode.new(val[1]) }
    ;

  logical_expression
    : inverse_expression
    | logical_expression AND inverse_expression { result = OperationNode.new(val[0], "and", val[2]) }
    | logical_expression OR inverse_expression { result = OperationNode.new(val[0], "or", val[2]) }
    ;

  filter
    : IDENTIFIER                    { result = FilterNode.new(val[0].value) }
    | IDENTIFIER ':' parameter_list { result = FilterNode.new(val[0].value, val[2]) }
    ;

  filter_list
    : filter { result = [val[0]] }
    | filter_list '|' filter { result = val[0].push(val[2]) }
    ;

  filtered_expression
    : logical_expression
    | logical_expression '|' filter_list { result = FilteredValueNode.new(val[0], val[2]) }
    ;

  inject_statement
    : VAR_OPEN filtered_expression VAR_CLOSE { result = InjectNode.new(val[1]) }
    ;

  if_tag
    : STMT_OPEN IF logical_expression STMT_CLOSE
      {
        @stack.push DocumentNode.new
        result = val[2]
      }
    ;

  unless_tag
    : STMT_OPEN UNLESS logical_expression STMT_CLOSE
      {
        @stack.push DocumentNode.new
        result = BooleanInverseNode.new(val[2])
      }
    ;

  else_tag
    : STMT_OPEN ELSE STMT_CLOSE { @stack.push DocumentNode.new }
    ;

  end_if_tag
    : STMT_OPEN ENDIF STMT_CLOSE
    ;

  end_unless_tag
    : STMT_OPEN ENDUNLESS STMT_CLOSE
    ;

  if_block
    : if_tag end_if_tag { @stack.pop; result = IfNode.new(val[0]) }
    | if_tag document end_if_tag { result = IfNode.new(val[0], @stack.pop.children) }
    | if_tag else_tag document end_if_tag
      {
        false_children, true_children = @stack.pop.children, @stack.pop.children
        result = IfNode.new(val[0], true_children, false_children)
      }
    | if_tag document else_tag end_if_tag
      {
        false_children, true_children = @stack.pop.children, @stack.pop.children
        result = IfNode.new(val[0], true_children, false_children)
      }
    | if_tag document else_tag document end_if_tag
      {
        false_children, true_children = @stack.pop.children, @stack.pop.children
        result = IfNode.new(val[0], true_children, false_children)
      }
    ;

  unless_block
    : unless_tag end_unless_tag { @stack.pop; result = IfNode.new(val[0]) }
    | unless_tag document end_unless_tag { result = IfNode.new(val[0], @stack.pop.children) }
    | unless_tag else_tag document end_unless_tag
      {
        false_children, true_children = @stack.pop.children, @stack.pop.children
        result = IfNode.new(val[0], true_children, false_children)
      }
    | unless_tag document else_tag end_unless_tag
      {
        false_children, true_children = @stack.pop.children, @stack.pop.children
        result = IfNode.new(val[0], true_children, false_children)
      }
    | unless_tag document else_tag document end_unless_tag
      {
        false_children, true_children = @stack.pop.children, @stack.pop.children
        result = IfNode.new(val[0], true_children, false_children)
      }
    ;

  for_tag
    : STMT_OPEN FOR IDENTIFIER IN filtered_expression STMT_CLOSE { result = [val[2].value, val[4]] }
    ;

  end_for_tag
    : STMT_OPEN ENDFOR STMT_CLOSE
    ;

  /* this has a shift/reduce conflict but since Racc will shift in this case it is the correct behavior */
  for_block
    : for_tag end_for_tag
      {
        iterator = VariableNode.new(val[0][0])
        iterable = val[0][1]
        
        result = ForNode.new(iterator, iterable, [])      
      }
    | for_tag { @stack.push DocumentNode.new } document end_for_tag
      {
        iterator = VariableNode.new(val[0][0])
        iterable = val[0][1]
        
        result = ForNode.new(iterator, iterable, @stack.pop.children)
      }
    ;

  block_tag
    : STMT_OPEN BLOCK IDENTIFIER STMT_CLOSE { result = val[2].value }
    ;

  end_block_tag
    : STMT_OPEN ENDBLOCK STMT_CLOSE
    ;

  /* this has a shift/reduce conflict but since Racc will shift in this case it is the correct behavior */
  block_block
    : block_tag end_block_tag { result = BlockNode.new(val[0], []) }
    | block_tag { @stack.push DocumentNode.new } document end_block_tag { result = BlockNode.new(val[0], @stack.pop.children) }
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
    | unless_block
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
# racc_parser.rb : generated by racc

---- inner ----
