(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
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

%%