(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
type token =
  | ASTERISK_2_RIGHT of Location.t
  | ASTERISK_2_LEFT of Location.t
  | ASTERISK_RIGHT of Location.t
  | ASTERISK_LEFT of Location.t
  | BLOCK_QUOTE_END of Location.t
  | BLOCK_QUOTE_START of Location.t
  | CIRCUMFLEX of Location.t
  | CIRCUMFLEX_RIGHT of Location.t
  | CIRCUMFLEX_LEFT of Location.t
  | CODE_BLOCK of (Location.t * string option * string)
  | COLON of Location.t
  | DECIMAL of Location.t
  | DISPLAY_MATH of Location.t
  | DOT of Location.t
  | EOF of Location.t
  | EQ of Location.t
  | EXCLAMATION of Location.t
  | HYPHEN of Location.t
  | IDENTIFIER of (Location.t * string)
  | INLINE_MATH of Location.t
  | LBRACKET of Location.t
  | LCBRACKET of Location.t
  | LPAREN of Location.t
  | NL of Location.t
  | NUMBERSIGN_1 of Location.t
  | NUMBERSIGN_2 of Location.t
  | NUMBERSIGN_3 of Location.t
  | NUMBERSIGN_4 of Location.t
  | NUMBERSIGN_5 of Location.t
  | NUMBERSIGN_6 of Location.t
  | OTHER_PLAIN of (Location.t * string)
  | PLUS of Location.t
  | RBRACKET of Location.t
  | RCBRACKET of Location.t
  | RPAREN of Location.t
  | SEMICOLON of Location.t
  | SPACE
  | TASK_LIST_START of (Location.t * bool)
  | TILDE_2_RIGHT of Location.t
  | TILDE_2_LEFT of Location.t
  | TILDE_RIGHT of Location.t
  | TILDE_LEFT of Location.t
  | URL of (Location.t * string)
  | VERBATIM of (Location.t * string)
  | VERTICAL of Location.t
[@@deriving show]
