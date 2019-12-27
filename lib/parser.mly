(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
%{
  open Syntax

  let noimpl () = failwith "not implemented"
%}
%token <Location.t> ASTERISK_2_LEFT
%token <Location.t> ASTERISK_2_RIGHT
%token <Location.t> ASTERISK_LEFT
%token <Location.t> ASTERISK_RIGHT
%token <Location.t> BLOCK_QUOTE_END
%token <Location.t> BLOCK_QUOTE_START
%token <Location.t> CIRCUMFLEX
%token <Location.t> CIRCUMFLEX_LEFT
%token <Location.t> CIRCUMFLEX_RIGHT
%token <Location.t * string option * string> CODE_BLOCK
%token <Location.t> COLON
%token <Location.t> DECIMAL
%token <Location.t> DISPLAY_MATH
%token <Location.t> DOT
%token <Location.t> EOF
%token <Location.t> EQ
%token <Location.t> EXCLAMATION
%token <Location.t> HYPHEN
%token <Location.t * string> IDENTIFIER
%token <Location.t> INLINE_MATH
%token <Location.t> LBRACKET
%token <Location.t> LCBRACKET
%token <Location.t> LPAREN
%token <Location.t> NL
%token <Location.t> NUMBERSIGN_1
%token <Location.t> NUMBERSIGN_2
%token <Location.t> NUMBERSIGN_3
%token <Location.t> NUMBERSIGN_4
%token <Location.t> NUMBERSIGN_5
%token <Location.t> NUMBERSIGN_6
%token <Location.t * string> OTHER_PLAIN
%token <Location.t> PLUS
%token <Location.t> RBRACKET 
%token <Location.t> RCBRACKET 
%token <Location.t> RPAREN
%token <Location.t> SEMICOLON
%token SPACE
%token <Location.t * bool> TASK_LIST_START
%token <Location.t> TILDE_2_LEFT
%token <Location.t> TILDE_2_RIGHT
%token <Location.t> TILDE_LEFT
%token <Location.t> TILDE_RIGHT
%token <Location.t * string> URL
%token <Location.t * string> VERBATIM
%token <Location.t> VERTICAL

%start<Syntax.document> document
%%

document : blocks EOF { Document $1 }

block: paragraph | h1 | h2 | h3 | h4 | h5 | h6 | block_quote | code_block | line_block | bullet_list | ordered_list | task_list
  | def_list | sep | table | note { $1 }

blocks: separated_nonempty_list(NL+, block) { $1 }

paragraph: line+ NL { Paragraph (List.concat $1) }

%inline
h(NS): NS SPACE inline option(LCBRACKET SPACE? NUMBERSIGN_1 IDENTIFIER SPACE? RCBRACKET { let _, id = $4 in id }) NL { $3, $4 }

h1: h(NUMBERSIGN_1) { let h, id = $1 in H1 (h, id) }
h2: h(NUMBERSIGN_2) { let h, id = $1 in H2 (h, id) }
h3: h(NUMBERSIGN_3) { let h, id = $1 in H3 (h, id) }
h4: h(NUMBERSIGN_4) { let h, id = $1 in H4 (h, id) }
h5: h(NUMBERSIGN_5) { let h, id = $1 in H5 (h, id) }
h6: h(NUMBERSIGN_6) { let h, id = $1 in H6 (h, id) }

block_quote: BLOCK_QUOTE_START blocks BLOCK_QUOTE_END { noimpl () }

code_block: CODE_BLOCK { let _, cls, body = $1 in CodeBlock (cls, body)}

line_block: nonempty_list(VERTICAL SPACE inline NL { $3 }) NL { noimpl () }

bullet_list: nonempty_list(ASTERISK_RIGHT SPACE bullet_list_content { $3 }) { noimpl () }
bullet_list_content: line | bullet_list_2 NL { noimpl () }
bullet_list_2: nonempty_list(SPACE PLUS SPACE bullet_list_2_content { $3 }) { noimpl () }
bullet_list_2_content: line | bullet_list_3 NL { noimpl () }
bullet_list_3: nonempty_list(SPACE HYPHEN SPACE line { $3 }) { noimpl () }

ordered_list: nonempty_list(DECIMAL DOT SPACE line { $1, $4 }) NL { noimpl () }

task_list: nonempty_list(TASK_LIST_START SPACE inline NL { let _, check = $1 in check, $3 }) NL { TaskList $1 }

(* MediaWiki-like definition list *)
def_list: nonempty_list(SEMICOLON SPACE line COLON SPACE line { $3, $6 }) NL { DefList $1 }

sep: HYPHEN+ NL { Sep }

table_row_line: VERTICAL nonempty_list(inline VERTICAL { $1 }) NL { $2 }

table_header_body_sep: PLUS nonempty_list(EQ+ PLUS { () }) NL { () }

table_row_sep: PLUS nonempty_list(HYPHEN+ PLUS { () }) NL { () }

table: table_row_sep table_row_line+ table_header_body_sep nonempty_list(table_row_line+ table_row_sep { noimpl () }) NL { noimpl () }

line: inline NL { $1 }

inline_part:
  | plain
  | link
  | emph
  | strong
  | verbatim
  | super_script
  | sub_script
  | del
  | inline_math
  | display_math
  | auto_link
  | image
  | note_ref { $1 }

inline: inline_part list(SPACE { [] } | inline_part { [$1] }) { $1 :: BatList.concat $2 }

emph: ASTERISK_LEFT inline ASTERISK_RIGHT { Emphasis $2 }
strong: ASTERISK_2_LEFT inline ASTERISK_2_RIGHT { Strong $2 }
super_script: CIRCUMFLEX_LEFT inline CIRCUMFLEX_RIGHT { SuperScript $2 }
sub_script: TILDE_LEFT inline TILDE_RIGHT { SubScript $2 }
del: TILDE_2_LEFT inline TILDE_2_RIGHT { Del $2 }

link: LBRACKET URL RBRACKET LPAREN inline RPAREN { noimpl () }

verbatim: VERBATIM { let _, text = $1 in Verbatim text }

inline_math: INLINE_MATH { noimpl () }

display_math: DISPLAY_MATH { noimpl () }

auto_link: URL { let _, url_text = $1 in Link (Url url_text, [Plain url_text]) }

image: EXCLAMATION LBRACKET URL RBRACKET LPAREN inline RPAREN { let _, url_text = $3 in Image (Url url_text, $6) }

note_ref: LBRACKET CIRCUMFLEX IDENTIFIER RBRACKET { let _, id = $3 in NoteRef id }

note: LBRACKET CIRCUMFLEX IDENTIFIER RBRACKET COLON SPACE line { noimpl () }

plain: IDENTIFIER | OTHER_PLAIN { let _, text = $1 in Plain text }
