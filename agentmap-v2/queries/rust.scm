; Rust queries

(function_item
  name: (identifier) @func_name)

(struct_item
  name: (type_identifier) @struct_name)

(enum_item
  name: (type_identifier) @enum_name)

(impl_item
  type: (type_identifier) @impl_type)

(trait_item
  name: (type_identifier) @trait_name)

(mod_item
  name: (identifier) @module_name)

(use_declaration) @import_name