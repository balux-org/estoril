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

import java.time.ZonedDateTime
import org.eclipse.jgit.lib._

case class Content(body: String, metaData: Map[String, String], tags: List[String], title: String, permalink: String, updatedAt: ZonedDateTime, createdAt: ZonedDateTime, urn: String)
