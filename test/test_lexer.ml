(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
open OUnit2
open Aux
open Estoril

let _ =
  begin_suite "Estoril.Lexer";
  test "lex" (fun _ ->
      let check source =
        Printf.printf "lexing '%s'\n" source;
        let { Lexer.read; _ } = Estoril.Lexer.from_string source in
        let rec loop () =
          match read () with
          | Estoril.Token.EOF _ -> ()
          | t ->
              Printf.printf "%s\n" (Token.show_token t);
              loop ()
        in
        loop ()
      in
      let lines =
        [
          "# header"; "This is a *emphasized string*, *emphasized string2*, and *emphasized string3*."; "## header2"; "";
        ]
      in
      let source = String.concat "\n" lines in
      check source;
      let source = "test" in
      Estoril.Lexer.parse Estoril.Parser.document (Estoril.Lexer.from_string source)
      |> Syntax.show_document |> Printf.printf "%s\n";
      assert_equal 0 0);
  end_suite ()
