(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)

open Token

let rec read token_buffer lexbuf =
  match !token_buffer with
  | h :: t ->
      token_buffer := t;
      h
  | [] -> (
      match read_raw lexbuf with
      | [] -> failwith "failed to read"
      | [ h ] -> h
      | h :: t ->
          token_buffer := t;
          h )

and read_raw lexbuf =
  let lexeme = Sedlexing.Utf8.lexeme in
  let loc lexbuf =
    let start, _ = Sedlexing.lexing_positions lexbuf in
    start
  in
  let read_symbol_after_space lexbuf space =
    match%sedlex lexbuf with
    | "**" -> [ space; ASTERISK_2_LEFT (loc lexbuf) ]
    | '*' -> [ space; ASTERISK_LEFT (loc lexbuf) ]
    | "~~" -> [ space; TILDE_2_LEFT (loc lexbuf) ]
    | '~' -> [ space; TILDE_LEFT (loc lexbuf) ]
    | '^' -> [ space; CIRCUMFLEX_LEFT (loc lexbuf) ]
    | _ -> [ space ]
  in
  let read_code_block lexbuf =
    let cls = match%sedlex lexbuf with Plus (Sub (any, '\n')) -> Some (lexeme lexbuf) | _ -> None in
    match%sedlex lexbuf with
    | Star (("\n``" | "\n`" | "\n"), Star (Sub (Sub (any, "`"), "\n"))), "\n```" ->
        let s = lexeme lexbuf in
        CODE_BLOCK (loc lexbuf, cls, String.sub s 0 (String.length s - 4))
    | _ -> failwith "unexpected end of code block"
  in
  match%sedlex lexbuf with
  | ( Plus 'a' .. 'z',
      "://",
      'a' .. 'z',
      Plus ('a' .. 'z' | '.'),
      Plus ('/' | 'a' .. 'z' | 'A' .. 'Z' | '%' | '0' .. '9' | '_' | '-'),
      Star ('#', 'a' .. 'z' | 'A' .. 'Z' | '%' | '0' .. '9' | '_' | '-') ) ->
      (* *subset* of URL *)
      [ URL (loc lexbuf, lexeme lexbuf) ]
  | Plus ' ' -> read_symbol_after_space lexbuf SPACE
  | "**", Plus ' ' -> [ ASTERISK_2_RIGHT (loc lexbuf); SPACE ]
  | '*', Plus ' ' -> [ ASTERISK_RIGHT (loc lexbuf); SPACE ]
  | "~~", Plus ' ' -> [ TILDE_2_RIGHT (loc lexbuf); SPACE ]
  | '~', Plus ' ' -> [ TILDE_RIGHT (loc lexbuf); SPACE ]
  | '^', Plus ' ' -> [ CIRCUMFLEX_RIGHT (loc lexbuf); SPACE ]
  | '>' -> assert false
  | ':' -> [ COLON (loc lexbuf) ]
  | '0' .. '9' | '1' .. '9', Star '0' .. '9' -> [ DECIMAL (loc lexbuf) ]
  | "$$", Star (Sub (any, '$')), "$$" -> [ DISPLAY_MATH (loc lexbuf) ]
  | '.' -> [ DOT (loc lexbuf) ]
  | '=' -> [ EQ (loc lexbuf) ]
  | '!' -> [ EXCLAMATION (loc lexbuf) ]
  | '-' -> [ HYPHEN (loc lexbuf) ]
  | ('a' .. 'z' | 'A' .. 'Z' | '_'), Star ('a' .. 'z' | 'A' .. 'Z' | '_' | '0' .. '9') ->
      [ IDENTIFIER (loc lexbuf, lexeme lexbuf) ]
  | '$', Star (Sub (any, '$')), '$' -> [ INLINE_MATH (loc lexbuf) ]
  | '[' -> [ LBRACKET (loc lexbuf) ]
  | '{' -> [ LCBRACKET (loc lexbuf) ]
  | '(' -> [ LPAREN (loc lexbuf) ]
  | "\n```" -> [ read_code_block lexbuf ]
  | '\n' -> [ NL (loc lexbuf) ]
  | "######" -> [ NUMBERSIGN_6 (loc lexbuf) ]
  | "#####" -> [ NUMBERSIGN_5 (loc lexbuf) ]
  | "####" -> [ NUMBERSIGN_4 (loc lexbuf) ]
  | "###" -> [ NUMBERSIGN_3 (loc lexbuf) ]
  | "##" -> [ NUMBERSIGN_2 (loc lexbuf) ]
  | '#' -> [ NUMBERSIGN_1 (loc lexbuf) ]
  | '+' -> [ PLUS (loc lexbuf) ]
  | ']' -> [ RBRACKET (loc lexbuf) ]
  | '}' -> [ RCBRACKET (loc lexbuf) ]
  | ')' -> [ RPAREN (loc lexbuf) ]
  | ';' -> [ SEMICOLON (loc lexbuf) ]
  | "- [ ]" -> [ TASK_LIST_START (loc lexbuf, false) ]
  | "- [x]" -> [ TASK_LIST_START (loc lexbuf, true) ]
  | '`', Sub (any, '`'), '`' ->
      let s = lexeme lexbuf in
      [ VERBATIM (loc lexbuf, String.sub s 1 (String.length s - 1)) ]
  | '|' -> [ VERTICAL (loc lexbuf) ]
  | any, Star (Sub (any, 0 .. 127)) -> [ OTHER_PLAIN (loc lexbuf, lexeme lexbuf) ]
  | _ -> [ EOF (loc lexbuf) ]

let from_sedlex lexbuf =
  let token_buffer = ref [] in
  fun () -> read token_buffer lexbuf

let from_string source = Sedlexing.Utf8.from_string source |> from_sedlex

let from_channel channel = Sedlexing.Utf8.from_channel channel |> from_sedlex

let from_file_descr fd = Unix.in_channel_of_descr fd |> from_channel

let from_filename filename = Unix.openfile filename [ Unix.O_RDONLY; Unix.O_CLOEXEC ] 0 |> from_file_descr
