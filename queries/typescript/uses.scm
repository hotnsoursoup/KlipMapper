; TypeScript/JavaScript uses

; Member access (obj.property)
(member_expression
  object: (identifier) @use.obj
  property: (property_identifier) @use.prop)

; Function calls
(call_expression
  function: (identifier) @use.call)

; Constructor calls  
(new_expression
  constructor: (identifier) @use.constructor)

; Generic type usage
(type_arguments
  (type_identifier) @use.type)

; Property access in types
(property_signature
  name: (property_identifier) @use.prop
  type: (type_annotation
    (type_identifier) @use.type))

; Variable references
(identifier) @use.id