(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)

open Token

type context = {
  token_buffer : Token.token list ref;
  in_em : bool ref;
  in_strong : bool ref;
  in_sub : bool ref;
  in_sup : bool ref;
  in_bracket : bool ref;
  prev_token : token option ref;
}

let new_context () =
  {
    token_buffer = ref [];
    in_em = ref false;
    in_strong = ref false;
    in_sub = ref false;
    in_sup = ref false;
    in_bracket = ref false;
    prev_token = ref None;
  }

let rec read context lexbuf =
  let ret =
    match !(context.token_buffer) with
    | h :: t ->
        context.token_buffer := t;
        h
    | [] -> (
        match read_raw context lexbuf with
        | [] -> failwith "failed to read"
        | [ h ] -> h
        | h :: t ->
            context.token_buffer := t;
            h )
  in
  context.prev_token := Some ret;
  ret

and read_raw context lexbuf =
  let lexeme = Sedlexing.Utf8.lexeme in
  let loc lexbuf =
    let start, _ = Sedlexing.lexing_positions lexbuf in
    start
  in
  let read_code_block lexbuf =
    let cls = match%sedlex lexbuf with Plus (Sub (any, '\n')) -> Some (lexeme lexbuf) | _ -> None in
    match%sedlex lexbuf with
    | Star (("\n``" | "\n`" | "\n"), Star (Sub (Sub (any, "`"), "\n"))), "\n```" ->
        let s = lexeme lexbuf in
        CODE_BLOCK (loc lexbuf, cls, String.sub s 0 (String.length s - 4))
    | _ -> failwith "unexpected end of code block"
  in
  let left_right state left right =
    if !state then (
      state := false;
      right )
    else (
      state := true;
      left )
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
  | Plus ' ' -> [ SPACE ]
  | "**" -> left_right context.in_strong [ ASTERISK_2_LEFT (loc lexbuf) ] [ ASTERISK_2_RIGHT (loc lexbuf) ]
  | "*" -> left_right context.in_em [ ASTERISK_LEFT (loc lexbuf) ] [ ASTERISK_RIGHT (loc lexbuf) ]
  | "~~" -> left_right context.in_sub [ TILDE_2_LEFT (loc lexbuf) ] [ TILDE_2_RIGHT (loc lexbuf) ]
  | "~" -> left_right context.in_sup [ TILDE_LEFT (loc lexbuf) ] [ TILDE_RIGHT (loc lexbuf) ]
  | "^" ->
      if !(context.in_bracket) then [ CIRCUMFLEX (loc lexbuf) ]
      else left_right context.in_sup [ CIRCUMFLEX_LEFT (loc lexbuf) ] [ CIRCUMFLEX_RIGHT (loc lexbuf) ]
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
  | '[' ->
      context.in_bracket := true;
      [ LBRACKET (loc lexbuf) ]
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
  | ']' ->
      context.in_bracket := false;
      [ RBRACKET (loc lexbuf) ]
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
  | _ -> (
      match !(context.prev_token) with
      | Some (EOF _) | Some (NL _) -> [ EOF (loc lexbuf) ]
      | _ ->
          (* auto-insert NL before EOF *)
          [ NL (loc lexbuf) ] )

type t = { read : unit -> Token.token; context : context; lexbuf : Sedlexing.lexbuf }

let from_sedlex lexbuf =
  let context = new_context () in
  { read = (fun () -> read context lexbuf); context; lexbuf }

let from_string source = Sedlexing.Utf8.from_string source |> from_sedlex

let from_channel channel = Sedlexing.Utf8.from_channel channel |> from_sedlex

let from_file_descr fd = Unix.in_channel_of_descr fd |> from_channel

let from_filename filename = Unix.openfile filename [ Unix.O_RDONLY; Unix.O_CLOEXEC ] 0 |> from_file_descr

let parse rule lexer =
  let lex () =
    let old_pos, _ = lexer.lexbuf |> Sedlexing.lexing_positions in
    let token = lexer.read () in
    let new_pos, _ = lexer.lexbuf |> Sedlexing.lexing_positions in
    (token, old_pos, new_pos)
  in
  MenhirLib.Convert.Simplified.traditional2revised rule lex
