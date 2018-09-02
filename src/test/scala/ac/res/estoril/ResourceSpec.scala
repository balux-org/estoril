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

import java.io.File

import org.fusesource.scalate.TemplateEngine
import org.fusesource.scalate.scaml.ScamlOptions

class ResourceSpec extends Spec {
  feature("Get resources from classpath") {
    scenario("Get style.styl") {
      assert(Resource.style.nonEmpty)
    }
    scenario("Get rust.styl") {
      assert(Resource.rust.nonEmpty)
    }
  }
  feature("Load Jade to Scalate template engine from classPath") {
    def testEngine = {
      val engine = new TemplateEngine
      engine.workingDirectory = new File("tmp")
      engine.allowReload = false
      engine.allowCaching = false
      ScamlOptions.format = ScamlOptions.Format.html5
      ScamlOptions.indent = ""
      engine
    }
    scenario("load layout.jade") {
      Resource.layout(testEngine)
    }
    scenario("load feed.jade") {
      Resource.layout(testEngine)
    }
  }
}
