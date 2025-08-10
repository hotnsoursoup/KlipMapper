; Python definitions

; Classes
(class_definition 
  name: (identifier) @def.class)

; Functions
(function_definition 
  name: (identifier) @def.fn)

; Async functions
(async_function_definition
  name: (identifier) @def.async_fn)

; Variables/assignments
(assignment
  target: (identifier) @def.var)

; Global variables
(global_statement
  (identifier) @def.global)

; Class variables
(class_definition
  body: (block
    (expression_statement
      (assignment
        target: (identifier) @def.class_var))))

; Decorators (important for frameworks like Flask/Django)
(decorated_definition
  (decorator
    (identifier) @def.decorator)
  definition: (function_definition
    name: (identifier) @def.decorated_fn))

; Lambda functions assigned to variables
(assignment
  target: (identifier) @def.lambda
  value: (lambda))