(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *)
open OUnit2

let _tests : test list ref = ref []

let _suite_name : string ref = ref ""

let begin_suite name = _suite_name := name

let test name test = _tests := (name >:: test) :: !_tests

let end_suite () =
  !_suite_name >::: List.rev !_tests |> run_test_tt_main;
  _suite_name := "";
  _tests := []
