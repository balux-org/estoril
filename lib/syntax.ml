(* Copyright (C) 2019 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * SPDX-Identifier: Apache-2.0 WITH LLVM-exception
 *)

type url = Url of string

type inline =
  | Plain of string
  | NoteRef of string
  | Image of url * inline list
  | Link of url * inline list
  | Verbatim of string
  | Del of inline list
  | SubScript of inline list
  | SuperScript of inline list
  | Emphasis of inline list
  | Strong of inline list

type table_row = inline list list

type block =
  | Table of table_row * table_row list
  | Sep
  | DefList of (inline list * inline list) list
  | TaskList of (bool * inline list) list
  | OrderedList of (int * inline list) list
  | H1 of inline list * string option
  | H2 of inline list * string option
  | H3 of inline list * string option
  | H4 of inline list * string option
  | H5 of inline list * string option
  | H6 of inline list * string option
  | Paragraph of inline list
  | CodeBlock of string option * string

type document = Document of block list
