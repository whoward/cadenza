#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.9
# from Racc grammer file "".
#

require 'racc/parser.rb'

# racc_parser.rb : generated by racc

module Cadenza
  class RaccParser < Racc::Parser

module_eval(<<'...end cadenza.y/module_eval...', 'cadenza.y', 194)

...end cadenza.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    37,    37,     3,    89,   116,    65,    66,    20,    21,    22,
    23,    24,    76,   107,    37,    75,    65,    66,     9,    67,
    56,    57,    90,    29,    33,    33,    34,    34,    37,   110,
    35,    35,    74,    36,    36,    85,    38,    38,    33,    37,
    34,    65,    66,     3,    35,    46,    83,    36,    71,   106,
    38,   123,    33,    37,    34,    77,    78,    79,    35,     9,
     3,    36,     4,    33,    38,    34,    65,    66,     3,    35,
    39,     3,    36,   121,   124,    38,     9,    33,    68,    34,
    72,    78,    79,    35,     9,   120,    36,     9,   115,    38,
    20,    21,    22,    23,    24,    20,    21,    22,    23,    24,
    20,    21,    22,    23,    24,   114,    29,    56,    57,    56,
    57,    29,    56,    57,    54,    55,    29,    20,    21,    22,
    23,    24,    20,    21,    22,    23,    24,    20,    21,    22,
    23,    24,   113,    29,    56,    57,    56,    57,    29,     3,
     3,   116,     4,    29,    20,    21,    22,    23,    24,    20,
    21,    22,    23,    24,   112,     9,     9,     3,   111,    87,
    29,     3,     3,    39,     4,    29,    20,    21,    22,    23,
    24,    83,     3,     9,     4,    56,    57,     9,     9,     3,
   109,     4,    29,    20,    21,    22,    23,    24,     9,     3,
     3,    46,   116,    54,    55,     9,    65,    66,   126,    29,
    20,    21,    22,    23,    24,     9,     9,    58,    59,    60,
    61,    62,    63,    58,    59,    60,    61,    62,    63,    20,
    21,    22,    23,    24,    20,    21,    22,    23,    24,    20,
    21,    22,    23,    24,    20,    21,    22,    23,    24,    20,
    21,    22,    23,    24,    20,    21,    22,    23,    24,    20,
    21,    22,    23,    24,    20,    21,    22,    23,    24,    20,
    21,    22,    23,    24,    20,    21,    22,    23,    24,    54,
    55,   127,   108,    89,    50,    43,   130,   103,    17,   103,
   133,    89 ]

racc_action_check = [
     4,    46,   118,    73,   118,    70,    70,    37,    37,    37,
    37,    37,    38,    70,   121,    38,    31,    31,   118,    31,
    98,    98,    53,    37,     4,    46,     4,    46,    39,    73,
     4,    46,    37,     4,    46,    46,     4,    46,   121,    87,
   121,    69,    69,     7,   121,     7,   121,   121,    35,    69,
   121,    85,    39,   116,    39,    39,    39,    39,    39,     7,
     8,    39,     8,    87,    39,    87,    51,    51,     5,    87,
     5,    84,    87,    84,    87,    87,     8,   116,    32,   116,
    36,   116,   116,   116,     5,    83,   116,    84,    79,   116,
    66,    66,    66,    66,    66,    20,    20,    20,    20,    20,
    24,    24,    24,    24,    24,    78,    66,    27,    27,   100,
   100,    20,    99,    99,    26,    26,    24,   108,   108,   108,
   108,   108,    65,    65,    65,    65,    65,    89,    89,    89,
    89,    89,    77,   108,    97,    97,    96,    96,    65,    82,
     0,    82,     0,    89,    33,    33,    33,    33,    33,    34,
    34,    34,    34,    34,    76,    82,     0,    49,    75,    49,
    33,    41,    42,    41,    42,    34,     3,     3,     3,     3,
     3,    43,     2,    49,     2,    95,    95,    41,    42,    45,
    72,    45,     3,   126,   126,   126,   126,   126,     2,    48,
    81,    48,    81,    94,    94,    45,   125,   125,   103,   126,
    55,    55,    55,    55,    55,    48,    81,    28,    28,    28,
    28,    28,    28,    64,    64,    64,    64,    64,    64,    56,
    56,    56,    56,    56,    57,    57,    57,    57,    57,    54,
    54,    54,    54,    54,    59,    59,    59,    59,    59,    60,
    60,    60,    60,    60,    61,    61,    61,    61,    61,    29,
    29,    29,    29,    29,    63,    63,    63,    63,    63,    58,
    58,    58,    58,    58,    62,    62,    62,    62,    62,    93,
    93,   105,    71,    52,    17,     6,   124,    67,     1,   127,
   128,   131 ]

racc_action_pointer = [
   116,   278,   148,   163,    -3,    44,   249,    19,    36,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   274,   nil,   nil,
    92,   nil,   nil,   nil,    97,   nil,   105,    96,   194,   246,
   nil,    -4,    53,   141,   146,    45,    77,     4,     9,    25,
   nil,   137,   138,   136,   nil,   155,    -2,   nil,   165,   133,
   nil,    46,   271,    14,   226,   197,   216,   221,   256,   231,
   236,   241,   261,   251,   200,   119,    87,   274,   nil,    21,
   -15,   238,   152,     1,   nil,   130,   126,   104,    77,    60,
   nil,   166,   115,    57,    47,    23,   nil,    36,   nil,   124,
   nil,   nil,   nil,   260,   184,   164,   125,   123,     9,   101,
    98,   nil,   nil,   176,   nil,   248,   nil,   nil,   114,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    50,   nil,   -22,   nil,
   nil,    11,   nil,   nil,   248,   176,   180,   276,   252,   nil,
   nil,   279,   nil,   nil ]

racc_action_default = [
    -2,   -71,    -1,   -71,   -71,   -71,   -49,   -71,   -71,   -61,
   -62,   -63,   -64,   -65,   -66,   -67,   -69,   -71,   -68,   -70,
    -5,    -7,    -8,    -9,   -71,   -11,   -14,   -17,   -24,   -71,
   -26,   -33,   -71,   -71,   -71,   -71,   -71,   -71,   -71,   -71,
   -41,   -71,   -71,   -71,   -48,   -71,   -71,   -53,   -71,   -71,
   134,    -3,    -6,   -71,   -71,   -71,   -71,   -71,   -71,   -71,
   -71,   -71,   -71,   -71,   -25,   -71,   -71,   -71,   -35,   -71,
   -71,   -71,   -71,   -71,   -55,   -71,   -71,   -71,   -71,   -71,
   -42,   -71,   -71,   -71,   -71,   -71,   -54,   -71,   -58,   -71,
   -10,   -12,   -13,   -15,   -16,   -18,   -19,   -20,   -21,   -22,
   -23,   -27,   -28,   -29,   -31,   -34,   -36,   -37,   -71,   -51,
   -56,   -59,   -60,   -38,   -39,   -40,   -71,   -44,   -71,   -43,
   -47,   -71,   -50,   -52,   -71,    -4,   -71,   -71,   -71,   -45,
   -57,   -30,   -32,   -46 ]

racc_goto_table = [
    18,    40,    51,    19,    52,   104,    32,    47,    44,    42,
    91,    92,   101,   102,    45,    69,    70,     2,   105,    51,
    88,    73,    41,    64,    48,    49,     1,    53,    95,    96,
    97,    98,    99,   100,    93,    94,   nil,    80,   nil,    18,
   nil,   nil,    19,   nil,   nil,    81,    18,    18,    86,    19,
    19,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    82,
   nil,   nil,    84,   nil,   nil,   132,   nil,   nil,   nil,   nil,
   nil,   125,   nil,   nil,   nil,   nil,   nil,   117,   119,   nil,
    18,   nil,    18,    19,   nil,    19,   122,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   118,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    51,   nil,
   131,   128,   nil,   nil,   129,   nil,    18,   nil,   nil,    19 ]

racc_goto_check = [
    29,    16,     4,    28,     3,    11,     6,    23,    19,    15,
     5,     5,    10,    10,    21,     4,     4,     2,    12,     4,
    26,     3,     2,     9,     2,     2,     1,     6,     8,     8,
     8,     8,     8,     8,     7,     7,   nil,    16,   nil,    29,
   nil,   nil,    28,   nil,   nil,    15,    29,    29,    23,    28,
    28,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     2,
   nil,   nil,     2,   nil,   nil,    11,   nil,   nil,   nil,   nil,
   nil,     4,   nil,   nil,   nil,   nil,   nil,    16,    16,   nil,
    29,   nil,    29,    28,   nil,    28,    19,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     2,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     4,   nil,
     3,     6,   nil,   nil,    16,   nil,    29,   nil,   nil,    28 ]

racc_goto_pointer = [
   nil,    26,    17,   -16,   -18,   -44,     3,   -22,   -30,    -6,
   -53,   -62,   -49,   nil,   nil,     4,    -4,   nil,   nil,     2,
   nil,     8,   nil,     0,   nil,   nil,   -29,   nil,     1,    -2 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    31,    25,   nil,    26,    27,    28,
    30,   nil,   nil,    10,     5,   nil,   nil,    11,     6,   nil,
    12,   nil,     7,   nil,    14,     8,   nil,    13,    16,    15 ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 42, :_reduce_none,
  0, 42, :_reduce_2,
  1, 44, :_reduce_3,
  3, 44, :_reduce_4,
  1, 46, :_reduce_5,
  2, 46, :_reduce_6,
  1, 46, :_reduce_7,
  1, 46, :_reduce_8,
  1, 46, :_reduce_9,
  3, 46, :_reduce_10,
  1, 48, :_reduce_none,
  3, 48, :_reduce_12,
  3, 48, :_reduce_13,
  1, 49, :_reduce_none,
  3, 49, :_reduce_15,
  3, 49, :_reduce_16,
  1, 50, :_reduce_none,
  3, 50, :_reduce_18,
  3, 50, :_reduce_19,
  3, 50, :_reduce_20,
  3, 50, :_reduce_21,
  3, 50, :_reduce_22,
  3, 50, :_reduce_23,
  1, 51, :_reduce_none,
  2, 51, :_reduce_25,
  1, 45, :_reduce_none,
  3, 45, :_reduce_27,
  3, 45, :_reduce_28,
  1, 52, :_reduce_29,
  3, 52, :_reduce_30,
  1, 53, :_reduce_31,
  3, 53, :_reduce_32,
  1, 47, :_reduce_none,
  3, 47, :_reduce_34,
  3, 54, :_reduce_35,
  4, 55, :_reduce_36,
  4, 55, :_reduce_37,
  3, 56, :_reduce_38,
  3, 57, :_reduce_none,
  3, 57, :_reduce_none,
  2, 58, :_reduce_41,
  3, 58, :_reduce_42,
  4, 58, :_reduce_43,
  4, 58, :_reduce_44,
  5, 58, :_reduce_45,
  6, 59, :_reduce_46,
  3, 60, :_reduce_none,
  2, 61, :_reduce_48,
  0, 62, :_reduce_49,
  4, 61, :_reduce_50,
  4, 63, :_reduce_51,
  3, 64, :_reduce_52,
  2, 65, :_reduce_53,
  3, 65, :_reduce_54,
  3, 66, :_reduce_55,
  4, 66, :_reduce_56,
  3, 67, :_reduce_57,
  3, 68, :_reduce_58,
  4, 69, :_reduce_59,
  4, 69, :_reduce_60,
  1, 70, :_reduce_61,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 70, :_reduce_none,
  1, 43, :_reduce_67,
  2, 43, :_reduce_68,
  1, 43, :_reduce_69,
  2, 43, :_reduce_70 ]

racc_reduce_n = 71

racc_shift_n = 134

racc_token_table = {
  false => 0,
  :error => 1,
  "," => 2,
  :IDENTIFIER => 3,
  :INTEGER => 4,
  :REAL => 5,
  :STRING => 6,
  "(" => 7,
  ")" => 8,
  "*" => 9,
  "/" => 10,
  "+" => 11,
  "-" => 12,
  :OP_EQ => 13,
  :OP_NEQ => 14,
  :OP_LEQ => 15,
  :OP_GEQ => 16,
  ">" => 17,
  "<" => 18,
  :NOT => 19,
  :AND => 20,
  :OR => 21,
  ":" => 22,
  "|" => 23,
  :VAR_OPEN => 24,
  :VAR_CLOSE => 25,
  :STMT_OPEN => 26,
  :IF => 27,
  :STMT_CLOSE => 28,
  :UNLESS => 29,
  :ELSE => 30,
  :ENDIF => 31,
  :ENDUNLESS => 32,
  :FOR => 33,
  :IN => 34,
  :ENDFOR => 35,
  :BLOCK => 36,
  :ENDBLOCK => 37,
  :END => 38,
  :EXTENDS => 39,
  :TEXT_BLOCK => 40 }

racc_nt_base = 41

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "\",\"",
  "IDENTIFIER",
  "INTEGER",
  "REAL",
  "STRING",
  "\"(\"",
  "\")\"",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "OP_EQ",
  "OP_NEQ",
  "OP_LEQ",
  "OP_GEQ",
  "\">\"",
  "\"<\"",
  "NOT",
  "AND",
  "OR",
  "\":\"",
  "\"|\"",
  "VAR_OPEN",
  "VAR_CLOSE",
  "STMT_OPEN",
  "IF",
  "STMT_CLOSE",
  "UNLESS",
  "ELSE",
  "ENDIF",
  "ENDUNLESS",
  "FOR",
  "IN",
  "ENDFOR",
  "BLOCK",
  "ENDBLOCK",
  "END",
  "EXTENDS",
  "TEXT_BLOCK",
  "$start",
  "target",
  "document",
  "parameter_list",
  "logical_expression",
  "primary_expression",
  "filtered_expression",
  "multiplicative_expression",
  "additive_expression",
  "boolean_expression",
  "inverse_expression",
  "filter",
  "filter_list",
  "inject_statement",
  "if_tag",
  "else_tag",
  "end_if_tag",
  "if_block",
  "for_tag",
  "end_for_tag",
  "for_block",
  "@1",
  "block_tag",
  "end_block_tag",
  "block_block",
  "generic_block_tag",
  "end_generic_block_tag",
  "generic_block",
  "extends_statement",
  "document_component" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

module_eval(<<'.,.,', 'cadenza.y', 8)
  def _reduce_2(val, _values, result)
     result = nil 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 12)
  def _reduce_3(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 13)
  def _reduce_4(val, _values, result)
     result = val[0].push(val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 18)
  def _reduce_5(val, _values, result)
     result = VariableNode.new(val[0].value) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 19)
  def _reduce_6(val, _values, result)
     result = VariableNode.new(val[0].value, val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 20)
  def _reduce_7(val, _values, result)
     result = ConstantNode.new(val[0].value) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 21)
  def _reduce_8(val, _values, result)
     result = ConstantNode.new(val[0].value) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 22)
  def _reduce_9(val, _values, result)
     result = ConstantNode.new(val[0].value) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 23)
  def _reduce_10(val, _values, result)
     result = val[1] 
    result
  end
.,.,

# reduce 11 omitted

module_eval(<<'.,.,', 'cadenza.y', 28)
  def _reduce_12(val, _values, result)
     result = OperationNode.new(val[0], "*", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 29)
  def _reduce_13(val, _values, result)
     result = OperationNode.new(val[0], "/", val[2]) 
    result
  end
.,.,

# reduce 14 omitted

module_eval(<<'.,.,', 'cadenza.y', 34)
  def _reduce_15(val, _values, result)
     result = OperationNode.new(val[0], "+", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 35)
  def _reduce_16(val, _values, result)
     result = OperationNode.new(val[0], "-", val[2]) 
    result
  end
.,.,

# reduce 17 omitted

module_eval(<<'.,.,', 'cadenza.y', 40)
  def _reduce_18(val, _values, result)
     result = OperationNode.new(val[0], "==", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 41)
  def _reduce_19(val, _values, result)
     result = OperationNode.new(val[0], "!=", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 42)
  def _reduce_20(val, _values, result)
     result = OperationNode.new(val[0], "<=", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 43)
  def _reduce_21(val, _values, result)
     result = OperationNode.new(val[0], ">=", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 44)
  def _reduce_22(val, _values, result)
     result = OperationNode.new(val[0], ">", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 45)
  def _reduce_23(val, _values, result)
     result = OperationNode.new(val[0], "<", val[2]) 
    result
  end
.,.,

# reduce 24 omitted

module_eval(<<'.,.,', 'cadenza.y', 50)
  def _reduce_25(val, _values, result)
     result = BooleanInverseNode.new(val[1]) 
    result
  end
.,.,

# reduce 26 omitted

module_eval(<<'.,.,', 'cadenza.y', 55)
  def _reduce_27(val, _values, result)
     result = OperationNode.new(val[0], "and", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 56)
  def _reduce_28(val, _values, result)
     result = OperationNode.new(val[0], "or", val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 60)
  def _reduce_29(val, _values, result)
     result = FilterNode.new(val[0].value) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 61)
  def _reduce_30(val, _values, result)
     result = FilterNode.new(val[0].value, val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 65)
  def _reduce_31(val, _values, result)
     result = [val[0]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 66)
  def _reduce_32(val, _values, result)
     result = val[0].push(val[2]) 
    result
  end
.,.,

# reduce 33 omitted

module_eval(<<'.,.,', 'cadenza.y', 71)
  def _reduce_34(val, _values, result)
     result = FilteredValueNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 75)
  def _reduce_35(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 79)
  def _reduce_36(val, _values, result)
     open_scope!; result = val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 80)
  def _reduce_37(val, _values, result)
     open_scope!; result = BooleanInverseNode.new(val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 84)
  def _reduce_38(val, _values, result)
     open_scope! 
    result
  end
.,.,

# reduce 39 omitted

# reduce 40 omitted

module_eval(<<'.,.,', 'cadenza.y', 93)
  def _reduce_41(val, _values, result)
     result = IfNode.new(val[0], close_scope!) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 94)
  def _reduce_42(val, _values, result)
     result = IfNode.new(val[0], close_scope!) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 97)
  def _reduce_43(val, _values, result)
            false_children = close_scope!
        true_children  = close_scope!
        result = IfNode.new(val[0], true_children, false_children)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 103)
  def _reduce_44(val, _values, result)
            false_children = close_scope!
        true_children  = close_scope!
        result = IfNode.new(val[0], true_children, false_children)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 109)
  def _reduce_45(val, _values, result)
            false_children = close_scope!
        true_children  = close_scope!
        result = IfNode.new(val[0], true_children, false_children)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 116)
  def _reduce_46(val, _values, result)
     result = [val[2].value, val[4]] 
    result
  end
.,.,

# reduce 47 omitted

module_eval(<<'.,.,', 'cadenza.y', 127)
  def _reduce_48(val, _values, result)
            iterator = VariableNode.new(val[0][0])
        iterable = val[0][1]
        
        result = ForNode.new(iterator, iterable, [])      
      
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 132)
  def _reduce_49(val, _values, result)
     open_scope! 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 134)
  def _reduce_50(val, _values, result)
            iterator = VariableNode.new(val[0][0])
        iterable = val[0][1]
        
        result = ForNode.new(iterator, iterable, close_scope!)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 142)
  def _reduce_51(val, _values, result)
     result = open_block_scope!(val[2].value) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 146)
  def _reduce_52(val, _values, result)
     result = close_block_scope! 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 151)
  def _reduce_53(val, _values, result)
     result = BlockNode.new(val[0], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 152)
  def _reduce_54(val, _values, result)
     result = BlockNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 156)
  def _reduce_55(val, _values, result)
     open_scope!; result = [val[1].value, []] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 157)
  def _reduce_56(val, _values, result)
     open_scope!; result = [val[1].value, val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 161)
  def _reduce_57(val, _values, result)
     result = close_scope! 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 165)
  def _reduce_58(val, _values, result)
     result = GenericBlockNode.new(val[0].first, val[2], val[0].last) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 169)
  def _reduce_59(val, _values, result)
     result = val[2].value 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 170)
  def _reduce_60(val, _values, result)
     result = VariableNode.new(val[2].value) 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 174)
  def _reduce_61(val, _values, result)
     result = TextNode.new(val[0].value) 
    result
  end
.,.,

# reduce 62 omitted

# reduce 63 omitted

# reduce 64 omitted

# reduce 65 omitted

# reduce 66 omitted

module_eval(<<'.,.,', 'cadenza.y', 183)
  def _reduce_67(val, _values, result)
     push val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 184)
  def _reduce_68(val, _values, result)
     push val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 185)
  def _reduce_69(val, _values, result)
     document.extends = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'cadenza.y', 186)
  def _reduce_70(val, _values, result)
     document.extends = val[1] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class RaccParser
  end   # module Cadenza
