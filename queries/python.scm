; Python starter queries

(function_definition
  name: (identifier) @func_name) @func_node

(class_definition
  name: (identifier) @class_name) @class_node

(import_statement
  name: (dotted_name) @import_name)

(import_from_statement
  module_name: (dotted_name) @import_name)

; Docstring directly above symbol
((expression_statement (string) @doc) .
  (function_definition) @func_node)

((expression_statement (string) @doc) .
  (class_definition) @class_node)
