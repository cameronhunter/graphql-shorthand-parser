start
  = WS* definitions:(Enum / Interface / Object)* WS*
    { return definitions; }
Enum
  = "enum" SPACE name:Type BEGIN_BODY values:EnumValueList CLOSE_BODY
    { return { type: "ENUM", name, values }; }

Interface
  = "interface" SPACE name:Type BEGIN_BODY fields:FieldList CLOSE_BODY
    { return { type: "INTERFACE", name, fields }; }

Object
  = "type" SPACE name:Type interfaces:(COLON list:TypeList { return list; })? BEGIN_BODY fields:FieldList CLOSE_BODY
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
  = name:Identifier args:(BEGIN_ARGS fields:FieldList CLOSE_ARGS { return fields; })? COLON type:ReturnType
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

BEGIN_BODY = WS* "{" WS*
CLOSE_BODY = WS* "}" WS*

BEGIN_ARGS = WS* "(" WS*
CLOSE_ARGS = WS* ")" WS*

COLON = WS* ":" WS*

WS = (SPACE / NEW_LINE)+

SEPARATOR = COMMA_SEP / EOL_SEP
COMMA_SEP = WS* "," WS*
EOL_SEP = SPACE* NEW_LINE SPACE*

SPACE = [ \t]+
NEW_LINE = ("\r\n" / [\r\n])+
