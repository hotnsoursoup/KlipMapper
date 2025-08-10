; TypeScript/JavaScript imports

; Default imports: import Foo from 'bar'
(import_statement
  (import_clause
    (identifier) @import.default)
  source: (string 
    (string_fragment) @import.source))

; Named imports: import { Foo, Bar as Baz } from 'module'
(import_statement
  (import_clause
    (named_imports
      (import_specifier
        name: (identifier) @import.name
        alias: (identifier)? @import.alias)))
  source: (string
    (string_fragment) @import.source))

; Namespace imports: import * as Foo from 'bar'
(import_statement
  (import_clause
    (namespace_import
      (identifier) @import.namespace))
  source: (string
    (string_fragment) @import.source))

; Dynamic imports: import('module')
(call_expression
  function: (import)
  arguments: (arguments
    (string
      (string_fragment) @import.dynamic)))

; Require calls: require('module')
(call_expression
  function: (identifier) @require_fn
  arguments: (arguments
    (string
      (string_fragment) @import.require)))
(#eq? @require_fn "require")