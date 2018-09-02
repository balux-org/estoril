/* Copyright (C) 2014,2016 Takezoe,Tomoaki <tomoaki3478@u8.nu>
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

import com.typesafe.scalalogging.LazyLogging

import scala.sys.process._
import java.io._
import java.nio.file._
import java.time._
import java.time.format._
import org.eclipse.jgit.lib._
import org.apache.commons.codec.binary.Base32

object Git extends LazyLogging {
  def updatedAt(path: Option[Path] = None): Option[ZonedDateTime] =
    try {
      (Seq("git", "log", "-1", "--date=iso", "--pretty=format:%ad") ++ path.toSeq.flatMap(x => Seq("--follow", x.toString))).lineStream
        .dropWhile(_.isEmpty)
        .headOption
        .map(ZonedDateTime.parse(_, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss Z")))
    } catch {
      case _: RuntimeException =>
        None
    }
  def createdAt(path: Option[Path] = None): Option[ZonedDateTime] =
    (Seq("git", "log", "--reverse", "--date=iso", "--pretty=format:%ad") ++ path.toSeq.flatMap(x => Seq("--follow", x.toString))).lineStream
      .dropWhile(_.isEmpty)
      .headOption
      .map(ZonedDateTime.parse(_, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss Z")))
  private[this] val GitDiffIndexLine = "index [0-9a-f]+\\.\\.([0-9a-f]+)".r
  def creationId(path: Path) =
    Seq("git", "log", "--full-index", "--reverse", "--follow", "-p", path.toString).lineStream.find(_.startsWith("index ")) match {
      case Some(GitDiffIndexLine(id)) => Some(ObjectId.fromString(id))
      case Some(x) =>
        logger.warn(s"Could not parse git index line $x")
        None
      case None =>
        logger.warn(s"Could not find the first blob id of $path")
        None
    }
  implicit class ObjectIdOps(val self: ObjectId) extends AnyVal {
    def toURN = {
      val bout = new ByteArrayOutputStream
      self.copyTo(bout)
      s"urn:sha1:${(new Base32).encodeToString(bout.toByteArray)}"
    }
  }
}
