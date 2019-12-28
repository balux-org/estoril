(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
open Aux
open Estoril.Aux
open Estoril

let _ =
  begin_suite "parse EstorilMarkdown";
  walk_dir "." (fun path ->
      if BatString.ends_with path ".estrl" then
        test path (fun _ ->
            Lexer.from_filename path |> Lexer.parse Parser.document |> Syntax.show_document |> Printf.printf "%s\n";
            Printf.printf "%s\n" path));
  end_suite ()
