start
  = WS* definitions:(Enum / Interface / Object / InputObject)* WS*
    { return definitions; }

Ident = $([a-z]([a-z0-9_]i)*)
TypeIdent = $([A-Z]([a-z0-9_]i)*)
EnumIdent = $([A-Z][A-Z0-9_]*)
NumberIdent = $([.+-]?[0-9]+([.][0-9]+)?)

Enum
  = description:Comment? "enum" SPACE name:TypeIdent BEGIN_BODY values:EnumIdentList CLOSE_BODY
    { return { type: "ENUM", name, ...(description && { description }), values }; }

Interface
  = description:Comment? "interface" SPACE name:TypeIdent BEGIN_BODY fields:FieldList CLOSE_BODY
    { return { type: "INTERFACE", name, ...(description && { description }), fields }; }

Object
  = description:Comment? "type" SPACE name:TypeIdent interfaces:(COLON list:TypeList { return list; })? BEGIN_BODY fields:FieldList CLOSE_BODY
    { return { type: "TYPE", name, ...(description && { description }), fields, ...(interfaces && { interfaces }) }; }

InputObject
  = description:Comment? "input" SPACE name:TypeIdent interfaces:(COLON list:TypeList { return list; })? BEGIN_BODY fields:InputFieldList CLOSE_BODY
    { return { type: "INPUT", name, ...(description && { description }), fields, ...(interfaces && { interfaces }) }; }

ReturnType
  = type:TypeIdent required:"!"?
    { return { type, ...(required && { required: !!required }) }; }
  / "[" type:TypeIdent "]"
    { return { type, list: true }; }

TypeList
  = head:TypeIdent tail:(COMMA_SEP type:TypeIdent { return type; })*
    { return [head, ...tail]; }

Field
  = description:Comment? name:Ident args:(BEGIN_ARGS fields:FieldList CLOSE_ARGS { return fields; })? COLON type:ReturnType
    { return { [name]: { ...type, ...(args && { args }), ...(description && { description }) } }; }

FieldList
  = head:Field tail:(EOL_SEP field:Field { return field; })*
    { return [head, ...tail].reduce((result, field) => ({ ...result, ...field }), {}); }

InputField
  = description:Comment? name:Ident args:(BEGIN_ARGS fields:FieldList CLOSE_ARGS { return fields; })? COLON type:ReturnType defaultValue:(EQUAL value:Literal { return value; })?
    { return { [name]: { ...type, ...(args && { args }), ...(description && { description }), ...(defaultValue && { defaultValue }) } }; }

InputFieldList
  = head:InputField tail:(EOL_SEP field:InputField { return field; })*
    { return [head, ...tail].reduce((result, field) => ({ ...result, ...field }), {}); }

EnumIdentList
  = head:EnumIdent tail:(EOL_SEP value:EnumIdent { return value; })*
    { return [head, ...tail]; }

Comment
  = LINE_COMMENT comment:(!EOL char:CHAR { return char; })* EOL_SEP
    { return comment.join("").trim(); }
  / "/*" comment:(!"*/" char:CHAR { return char; })* "*/" EOL_SEP
    { return comment.join("").replace(/\n\s*[*]?\s*/g, " ").replace(/\s+/, " ").trim(); }

Literal
  = StringLiteral / BooleanLiteral / NumericLiteral

StringLiteral
  = '"' chars:DoubleStringCharacter* '"' { return chars.join(""); }

DoubleStringCharacter
  = !('"' / "\\" / EOL) . { return text(); }

BooleanLiteral
  = "true"  { return true }
  / "false"  { return false }

NumericLiteral
  = value:NumberIdent { return Number(value.replace(/^[.]/, '0.')); }

LINE_COMMENT = "#" / "//"

BEGIN_BODY = WS* "{" WS*
CLOSE_BODY = WS* "}" WS*

BEGIN_ARGS = WS* "(" WS*
CLOSE_ARGS = WS* ")" WS*

CHAR = .

WS = (SPACE / EOL)+

COLON = WS* ":" WS*
EQUAL = WS* "=" WS*

COMMA_SEP = WS* "," WS*
EOL_SEP = SPACE* EOL SPACE*

SPACE = [ \t]+
EOL = "\n" / "\r\n" / "\r" / "\u2028" / "\u2029"
