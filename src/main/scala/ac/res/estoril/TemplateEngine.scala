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

import java.io.InputStream
import java.net.URI
import java.nio.file.Files
import java.nio.file.Paths
import java.nio.file.StandardOpenOption

import org.fusesource.scalate.util.Resource

class TemplateEngine extends org.fusesource.scalate.TemplateEngine with Utils {
  resourceLoader = _uri =>
    new Resource {
      override def uri: String = _uri

      lazy val path = Paths.get(new URI(uri))

      override def inputStream: InputStream = {
        Files.newInputStream(path, StandardOpenOption.READ)
      }

      override def lastModified: Long = Files.getLastModifiedTime(path).toMillis
  }

}
