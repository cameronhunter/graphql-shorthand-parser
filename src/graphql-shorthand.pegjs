start
  = WS* definitions:(Enum / Interface / Object)* WS*
    { return definitions; }
Enum
  = "enum" SPACE name:Type begin_body values:EnumValueList close_body
    { return { type: "ENUM", name, values }; }

Interface
  = "interface" SPACE name:Type begin_body fields:FieldList close_body
    { return { type: "INTERFACE", name, fields }; }

Object
  = "type" SPACE name:Type interfaces:(COLON list:TypeList { return list; })? begin_body fields:FieldList close_body
    { return { type: "TYPE", name, fields, ...(interfaces && { interfaces }) }; }

Identifier
  = [a-z]([a-z0-9_]i)*
    { return text(); }

ReturnType
  = type:Type required:"!"?
    { return { type, ...(required ? { required: !!required } : {}) }; }
  / "[" type:Type "]"
    { return { type, list: true }; }

Type
  = [A-Z]([a-z0-9_]i)*
    { return text(); }

TypeList
  = head:Type tail:(SEPARATOR type:Type { return type; })*
    { return [head, ...tail]; }

Field
  = name:Identifier args:(begin_args fields:FieldList close_args { return fields; })? COLON type:ReturnType
    { return { [name]: { ...type, ...(args && { args }) } }; }

FieldList
  = head:Field tail:(SEPARATOR field:Field { return field; })*
    { return [head, ...tail].reduce((result, field) => ({ ...result, ...field }), {}); }

EnumValue
  = [A-Z][A-Z0-9_]+
    { return text(); }

EnumValueList
  = head:EnumValue tail:(SEPARATOR value:EnumValue { return value; })*
    { return [head, ...tail]; }

SEPARATOR
  = COMMA_SEP / EOL_SEP

COMMA_SEP
  = WS* "," WS*

EOL_SEP
  = SPACE* NEW_LINE SPACE*

NEW_LINE
  = ("\r\n" / [\r\n])+

SPACE
  = [ \t]+

WS
  = (SPACE / NEW_LINE)+

COLON
  = WS* ":" WS*

begin_body
  = WS* "{" WS*

close_body
  = WS* "}" WS*

begin_args
  = WS* "(" WS*

close_args
  = WS* ")" WS*
