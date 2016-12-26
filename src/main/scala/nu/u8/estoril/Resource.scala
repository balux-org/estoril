/* Copyright (C) 2016 Takezoe,Tomoaki <tomoaki3478@u8.nu>
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
package nu.u8.estoril

import java.net.URI
import java.nio.file.{ Files, Path, Paths }

import org.fusesource.scalate.{ Template, TemplateEngine }

object Resource {
  private[this] def classLoader = getClass.getClassLoader
  private[this] def nameToPath(name: String): Path = Paths.get(classLoader.getResource(s"nu/u8/estoril/$name").toURI)
  private[this] def load(name: String): String =
    new String(Files.readAllBytes(nameToPath(name)))
  private[this] def loadJade(name: String)(templateEngine: TemplateEngine): Template =
    templateEngine.load(nameToPath(name).toFile)
  val layout: TemplateEngine => Template = loadJade("layout.jade")
  val feed: TemplateEngine => Template = loadJade("feed.jade")
  lazy val rust = load("rust.styl")
  lazy val style = load("style.styl")
}
