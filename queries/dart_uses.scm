; Unqualified identifiers
(identifier) @use.id

; Type contexts (classes, annotations, constructors)
(type_identifier) @use.id
(constructor_identifier) @use.id

; Qualified identifiers: prefix.Name
(prefixed_identifier
  prefix: (identifier) @use.prefix
  (identifier) @use.id)