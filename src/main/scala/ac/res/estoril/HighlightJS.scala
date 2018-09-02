/* Copyright (C) 2014,2016,2018 Takezoe,Tomoaki <tomoaki3478@res.ac>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package ac.res.estoril

object HighlightJS {
  val languages = List(
    "1c",
    "actionscript",
    "apache",
    "applescript",
    "asciidoc",
    "autohotkey",
    "avrasm",
    "axapta",
    "bash",
    "brainfuck",
    "clojure",
    "cmake",
    "coffeescript",
    "cpp",
    "cs",
    "css",
    "d",
    "delphi",
    "diff",
    "django",
    "dos",
    "erlang-repl",
    "erlang",
    "fix",
    "fsharp",
    "glsl",
    "go",
    "haml",
    "handlebars",
    "haskell",
    "http",
    "ini",
    "java",
    "javascript",
    "json",
    "lasso",
    "lisp",
    "livecodeserver",
    "lua",
    "makefile",
    "markdown",
    "mathematica",
    "matlab",
    "mel",
    "mizar",
    "nginx",
    "objectivec",
    "ocaml",
    "oxygene",
    "parser3",
    "perl",
    "php",
    "profile",
    "python",
    "r",
    "rib",
    "rsl",
    "ruby",
    "ruleslanguage",
    "rust",
    "scala",
    "scilab",
    "scss",
    "smalltalk",
    "sql",
    "tex",
    "vala",
    "vbnet",
    "vbscript",
    "vhdl",
    "xml"
  )

  val MarkdownCodeFenceStart = "^```(.+)$".r
  def dependencies(markdownText: String): Set[String] =
    markdownText.lines.flatMap {
      case MarkdownCodeFenceStart(lang) if languages.contains(lang) => Some(lang)
      case _ => None
    }.toSet
}
