(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
open OUnit2
open Aux

let _ =
  begin_suite "Estoril.Lexer";
  test "lex header" (fun _ ->
      let lexer = Estoril.Lexer.from_string "# test" in
      Printf.printf "%s\n" (Estoril.Token.show_token (lexer ()));
      Printf.printf "%s\n" (Estoril.Token.show_token (lexer ()));
      Printf.printf "%s\n" (Estoril.Token.show_token (lexer ()));
      Printf.printf "%s\n" (Estoril.Token.show_token (lexer ()));
      assert_equal 0 0);
  end_suite ()
