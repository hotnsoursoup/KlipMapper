; Go queries

(function_declaration
  name: (identifier) @func_name)

(method_declaration
  name: (field_identifier) @method_name)

(type_declaration
  (type_spec
    name: (type_identifier) @type_name))

(package_clause
  (package_identifier) @package_name)

(import_spec) @import_name