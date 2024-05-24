[
  (compound_statement)
  (field_declaration_list)
] @indent.begin

(compound_statement
  "}" @indent.end)

(compound_statement
  "{" @indent.begin)

(if_statement
  ) @indent.begin

(if_statement
  consequence: (expression_statement) @indent.end)

(if_statement
  alternative: (else_clause) @indent.begin)


[
 ("}")
] @indent.branch

([
  (enumerator_list)
] @indent.align
  (#set! indent.open_delimiter "{")
  (#set! indent.close_delimiter "}")
  (#set! indent.avoid_last_matching_next))

([
  (argument_list)
  (parameter_list)
] @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")")
  (#set! indent.avoid_last_matching_next))

[
  "#define"
  "#ifdef"
  "#ifndef"
  "#elif"
  "#if"
  "#else"
  "#endif"
] @indent.zero

[
  (preproc_def)
  (preproc_ifdef)
  (preproc_elif)
  (preproc_if)
  (preproc_else)
] @indent.zero

[
  (preproc_arg)
  (string_literal)
] @indent.ignore
