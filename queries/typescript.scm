; TypeScript / JavaScript starter queries

(function_declaration
  name: (identifier) @func_name) @func_node

(method_definition
  name: (property_identifier) @method_name) @method_node

(class_declaration
  name: (identifier) @class_name) @class_node

(import_clause
  (import_specifier
    name: (identifier) @import_name))

(import_statement
  source: (string) @import_name)

; JSDoc above symbol (optional)
((comment) @doc .
  [
    (function_declaration) @func_node
    (class_declaration) @class_node
    (method_definition) @method_node
  ])
