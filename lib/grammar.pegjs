{
  const check = (obj) => obj ? { obj } : {};
}

start
  = ws* definitions:(interface / object / enum)* ws*
    { return definitions; }

newline
  = "\r\n" / [\r\n]

ws
  = [ \t] / newline

lowercase
  = [a-z]

uppercase
  = [A-Z]

key
  = ws* first:lowercase rest:(lowercase / uppercase)* ws*
    { return first + rest.join(""); }

type
  = first:uppercase rest:(lowercase / uppercase)*
    { return first + rest.join(""); }

commaseparated_type
  = ws* [,]? ws* type:type ws*
    { return type; }

commaseparated_field
  = ws* [,]? ws* field:field ws*
    { return field; }

typelist
  = ws* first:type rest:commaseparated_type* ws*
    { return [first].concat(rest); }

field_type
  = ws* type:type required:[!]? ws*
    { return { type, required: !!required }; }
  / ws* "[" type:type "]" required:[!]? ws*
    { return { type, required: !!required, array: true }; }

params
  = "(" args:field ")"
    { return args; }
  / "(" first:field rest:commaseparated_field* ")"
    { return Object.assign.apply(null, [first].concat(rest)); }

field
  = key:key args:params? ":" type:field_type ws* description:comment?
    { return { [key]: Object.assign(check(description), type, check(args)) }; }

fields
  = ws* "{" ws* fields:field+ ws* "}" ws*
    { return Object.assign.apply(null, fields); }

comment
  = ws* "//" comment:[A-Za-z0-9, \t]+ ws*
    { return comment.join("").trim() }

interface
  = description:comment? "interface" ws+ name:type ws* fields:fields
    { return Object.assign({ type: "INTERFACE", name }, check(description), { fields }); }

object
  = description:comment? "type" ws+ name:type ws* [:]? ws* interfaces:typelist? fields:fields
    { return Object.assign({ type: "TYPE", name }, check(description), { fields }, check(interfaces)); }

enum_value
  = ws* name:[A-Z]+ ws*
    { return name.join(""); }

enum
  = description:comment? "enum" ws+ name:type ws* "{" ws* values:enum_value+ ws* "}" ws*
    { return Object.assign({ type: "ENUM", name }, check(description), { values }); }
