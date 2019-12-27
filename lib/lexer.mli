(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
val from_sedlex : Sedlexing.lexbuf -> unit -> Parser.token

val from_string : string -> unit -> Parser.token

val from_channel : in_channel -> unit -> Parser.token

val from_file_descr : Unix.file_descr -> unit -> Parser.token

val from_filename : string -> unit -> Parser.token
