; Rust definitions

; Structs
(struct_item
  name: (type_identifier) @def.struct)

; Enums
(enum_item
  name: (type_identifier) @def.enum)

; Functions
(function_item
  name: (identifier) @def.fn)

; Traits
(trait_item
  name: (type_identifier) @def.trait)

; Implementations
(impl_item
  trait: (type_identifier)? @def.impl_trait
  type: (type_identifier) @def.impl_type)

; Modules
(mod_item
  name: (identifier) @def.module)

; Constants
(const_item
  name: (identifier) @def.const)

; Static variables
(static_item
  name: (identifier) @def.static)

; Type aliases
(type_item
  name: (type_identifier) @def.type_alias)

; Macros
(macro_definition
  name: (identifier) @def.macro)