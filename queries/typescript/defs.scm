; TypeScript/JavaScript definitions

; Classes
(class_declaration 
  name: (identifier) @def.class)

; Functions  
(function_declaration 
  name: (identifier) @def.fn)

; Arrow functions assigned to variables
(variable_declarator
  name: (identifier) @def.fn
  value: (arrow_function))

; Methods in classes
(method_definition
  name: (property_identifier) @def.method)

; Interfaces
(interface_declaration
  name: (type_identifier) @def.interface)

; Types
(type_alias_declaration
  name: (type_identifier) @def.type)

; Enums
(enum_declaration
  name: (identifier) @def.enum)

; Variables/Constants
(variable_declarator
  name: (identifier) @def.var)

; Namespace/Module
(module_declaration
  name: (identifier) @def.module)