; Rust uses

; Field access (struct.field)
(field_expression
  value: (identifier) @use.obj
  field: (field_identifier) @use.field)

; Method calls (obj.method())
(call_expression
  function: (field_expression
    value: (identifier) @use.obj
    field: (field_identifier) @use.method))

; Function calls
(call_expression
  function: (identifier) @use.call)

; Scoped calls (Module::function)
(call_expression
  function: (scoped_identifier
    path: (identifier) @use.scope
    name: (identifier) @use.scoped_fn))

; Type usage in generics
(type_arguments
  (type_identifier) @use.type)

; Pattern matching
(match_pattern
  (identifier) @use.pattern)

; Variable references
(identifier) @use.id

; Macro calls
(macro_invocation
  macro: (identifier) @use.macro)