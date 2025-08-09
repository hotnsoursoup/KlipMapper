; Dart / Flutter starter queries

; Classes
(class_definition
  name: (identifier) @class_name) @class_node

; Flutter base classes
(class_definition
  name: (identifier) @flutter_class_name
  super_class: (type_identifier) @super_name)
(#match? @super_name "StatelessWidget|StatefulWidget")

; Methods and functions
(method_signature
  name: (identifier) @method_name) @method_node

(function_signature
  name: (identifier) @func_name) @func_node

; Build method (Flutter)
(method_signature
  name: (identifier) @build_method)
(#eq? @build_method "build")

; Imports and exports
[
  (import_or_export
    (import_specification (uri) @import_name))
  (import_or_export
    (export_specification (uri) @import_name))
]

; Constructor-style calls FooBar(...)
(call_expression
  function: (identifier) @ctor_name) @call_node

; Doc comment above symbol (optional)
((comment) @doc .
  [
    (class_definition) @class_node
    (method_signature) @method_node
    (function_signature) @func_node
  ])
