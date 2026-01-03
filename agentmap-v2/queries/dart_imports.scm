; Import names and optional alias
(import_specification
  uri: (_) @import.uri
  (identifier) @import.name)?

(import_specification 
  namespace: (identifier) @import.alias)