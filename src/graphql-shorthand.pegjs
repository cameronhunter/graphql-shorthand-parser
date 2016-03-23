start
  = SEP* definitions:(Enum / Interface / Object)* WS*
    { return definitions; }

Ident = $([a-z]([a-z0-9_]i)*)
TypeIdent = $([A-Z]([a-z0-9_]i)*)
EnumIdent = $([A-Z][A-Z0-9_]*)

Enum
  = description:Comment? "enum" SEP name:TypeIdent BEGIN_BODY values:EnumIdentList CLOSE_BODY
    { return { type: "ENUM", name, ...(description && { description }), values }; }

Interface
  = description:Comment? "interface" SEP name:TypeIdent BEGIN_BODY fields:FieldList CLOSE_BODY
    { return { type: "INTERFACE", name, ...(description && { description }), fields }; }

Object
  = description:Comment? "type" SEP name:TypeIdent interfaces:(COLON list:TypeList { return list; })? BEGIN_BODY fields:FieldList CLOSE_BODY
    { return { type: "TYPE", name, ...(description && { description }), fields, ...(interfaces && { interfaces }) }; }

ReturnType
  = type:TypeIdent required:"!"?
    { return { type, ...(required && { required: !!required }) }; }
  / "[" type:TypeIdent "]"
    { return { type, list: true }; }

TypeList
  = head:TypeIdent tail:(SEP type:TypeIdent { return type; })*
    { return [head, ...tail]; }

Field
  = description:Comment? name:Ident args:(BEGIN_ARGS fields:FieldList CLOSE_ARGS { return fields; })? COLON type:ReturnType
    { return { [name]: { ...type, ...(args && { args }), ...(description && { description }) } }; }

FieldList
  = head:Field tail:(SEP field:Field { return field; })*
    { return [head, ...tail].reduce((result, field) => ({ ...result, ...field }), {}); }

EnumIdentList
  = head:EnumIdent tail:(SEP value:EnumIdent { return value; })*
    { return [head, ...tail]; }

Comment
  = LINE_COMMENT comment:(!EOL char:CHAR { return char; })* EOL_SEP
    { return comment.join("").trim(); }
  / "/*" comment:(!"*/" char:CHAR { return char; })* "*/" EOL_SEP
    { return comment.join("").replace(/\n\s*[*]?\s*/g, " ").replace(/\s+/, " ").trim(); }

LINE_COMMENT = "#" / "//"

BEGIN_BODY = WS* "{" WS*
CLOSE_BODY = WS* "}" WS*

BEGIN_ARGS = WS* "(" WS*
CLOSE_ARGS = WS* ")" WS*

CHAR = .

WS = (SPACE / EOL)+

COLON = WS* ":" WS*

COMMA_SEP = WS* "," WS*
EOL_SEP = SPACE* EOL SPACE*

SEP = (COMMA_SEP / EOL_SEP / WS)+

SPACE = [ \t]+
EOL = "\n" / "\r\n" / "\r" / "\u2028" / "\u2029"
