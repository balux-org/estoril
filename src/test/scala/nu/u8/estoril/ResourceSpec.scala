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

class ResourceSpec extends Spec {
  feature("Get resources from classpath") {
    scenario("Get layout.jade") {
      assert(Resource.layout.nonEmpty)
    }
    scenario("Get feed.jade") {
      assert(Resource.feed.nonEmpty)
    }
    scenario("Get style.styl") {
      assert(Resource.style.nonEmpty)
    }
    scenario("Get rust.styl") {
      assert(Resource.rust.nonEmpty)
    }
  }
}
