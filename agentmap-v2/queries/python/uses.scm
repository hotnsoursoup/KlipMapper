; Python uses

; Attribute access (obj.attr)
(attribute
  object: (identifier) @use.obj
  attribute: (identifier) @use.attr)

; Function calls
(call
  function: (identifier) @use.call)

; Method calls (obj.method())
(call
  function: (attribute
    object: (identifier) @use.obj
    attribute: (identifier) @use.method))

; Subscript access (obj[key])
(subscript
  value: (identifier) @use.subscript_obj)

; Class instantiation  
(call
  function: (identifier) @use.constructor
  (#match? @use.constructor "^[A-Z]"))

; Variable references
(identifier) @use.id

; Self references in methods
(attribute
  object: (identifier) @use.self
  (#eq? @use.self "self"))