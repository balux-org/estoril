(* Copyright (C) 2018-2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)

type t = Lexing.position

let pp formatter t =
  let pp = Format.pp_print_string formatter in
  let pp_int = Format.pp_print_int formatter in
  pp "<";
  t.Lexing.pos_fname |> pp;
  pp ":";
  t.Lexing.pos_lnum |> pp_int;
  pp ":";
  t.Lexing.pos_cnum |> pp_int;
  pp ">"
