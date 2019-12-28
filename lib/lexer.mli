(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
type context

type t = { read : unit -> Token.token; context : context; lexbuf : Sedlexing.lexbuf }

val from_sedlex : Sedlexing.lexbuf -> t

val from_string : string -> t

val from_channel : in_channel -> t

val from_file_descr : Unix.file_descr -> t

val from_filename : string -> t

val parse : (Token.token, 'a) MenhirLib.Convert.traditional -> t -> 'a
