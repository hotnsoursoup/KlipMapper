; Python imports

; Simple imports: import foo
(import_statement
  name: (dotted_name) @import.module)

; Aliased imports: import foo as bar
(import_statement
  name: (aliased_import
    name: (dotted_name) @import.name
    alias: (identifier) @import.alias))

; From imports: from foo import bar
(import_from_statement
  module_name: (dotted_name) @import.from_module
  name: (dotted_name) @import.from_name)

; From imports with alias: from foo import bar as baz
(import_from_statement
  module_name: (dotted_name) @import.from_module
  name: (aliased_import
    name: (dotted_name) @import.from_name
    alias: (identifier) @import.from_alias))

; Wildcard imports: from foo import *
(import_from_statement
  module_name: (dotted_name) @import.wildcard_module
  name: (wildcard_import))

; Relative imports: from .foo import bar
(import_from_statement
  module_name: (relative_import
    (dotted_name) @import.relative_module)
  name: (dotted_name) @import.relative_name)