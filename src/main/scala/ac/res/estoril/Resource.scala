/* Copyright (C) 2016,2018 Takezoe,Tomoaki <tomoaki3478@res.ac>
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

import java.net.URI
import java.nio.file._

import org.fusesource.scalate.Template
import org.fusesource.scalate.TemplateEngine

import scala.collection.mutable
import scala.collection.JavaConverters._

object Resource {
  private[this] def classLoader = getClass.getClassLoader
  private[this] var cache = new mutable.HashMap[URI, FileSystem]()
  def nameToPath(name: String): Path = {
    val uri = classLoader.getResource(s"ac/res/estoril/$name").toURI
    if (uri.getScheme != "file")
      try {
        FileSystems.getFileSystem(uri)
      } catch {
        case _: FileSystemNotFoundException =>
          FileSystems.newFileSystem(uri, mutable.Map("create" -> true).asJava)
      }
    Paths.get(uri)
  }
  private[this] def load(name: String): String =
    new String(Files.readAllBytes(nameToPath(name)))
  type Layout = Map[String, Any] => String
  private[this] def loadJade(name: String)(templateEngine: TemplateEngine): Layout = {
    val template = templateEngine.load(nameToPath(name).toUri.toString)
    attrs =>
      templateEngine.layout(template.source.uri, template, attrs)
  }
  val layout: TemplateEngine => Layout = loadJade("layout.jade")
  val feed: TemplateEngine => Layout = loadJade("feed.jade")
  lazy val rust = load("rust.styl")
  lazy val style = load("style.styl")
}
