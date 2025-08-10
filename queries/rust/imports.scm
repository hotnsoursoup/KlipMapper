; Rust imports (use statements)

; Simple use: use foo;
(use_declaration
  argument: (identifier) @import.simple)

; Scoped use: use foo::bar;
(use_declaration
  argument: (scoped_identifier
    path: (identifier) @import.path
    name: (identifier) @import.name))

; Nested scoped use: use foo::bar::baz;
(use_declaration
  argument: (scoped_identifier) @import.scoped)

; Aliased use: use foo as bar;
(use_declaration
  argument: (use_as_clause
    path: (identifier) @import.original
    alias: (identifier) @import.alias))

; Use list: use foo::{bar, baz};
(use_declaration
  argument: (use_list
    path: (identifier) @import.list_path))

; Wildcard use: use foo::*;
(use_declaration
  argument: (use_wildcard
    (scoped_identifier
      path: (identifier) @import.wildcard_path)))

; External crate: extern crate foo;
(extern_crate_declaration
  name: (identifier) @import.extern_crate)