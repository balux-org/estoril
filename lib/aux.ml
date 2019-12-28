(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-Identifier: Apache-2.0 WITH LLVM-exception
 *)

let walk_dir_handle dir f =
  try
    while true do
      Unix.readdir dir |> f
    done
  with End_of_file -> ()

let walk_dir path f =
  let dir = Unix.opendir path in
  walk_dir_handle dir f;
  (* TODO: finally *)
  Unix.closedir dir
