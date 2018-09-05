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

import com.typesafe.scalalogging.LazyLogging
import org.fusesource.scalate.RenderContext
import org.fusesource.scalate.TemplateEngine
import org.fusesource.scalate.TemplateEngineAddOn
import org.fusesource.scalate.filter.Filter

import com.vladsch.flexmark.html.HtmlRenderer
import com.vladsch.flexmark.parser.Parser
import com.vladsch.flexmark.util.options.MutableDataSet

object MarkdownFilter extends Filter with TemplateEngineAddOn with LazyLogging {
  def convert(source: String): String = {
    val options = new MutableDataSet()
    val parser = Parser.builder(options).build()
    val renderer = HtmlRenderer.builder(options).build()
    val document = parser.parse(source)
    renderer.render(document)
  }
  def filter(context: RenderContext, content: String): String = convert(content)
  def apply(te: org.fusesource.scalate.TemplateEngine): Unit = {
    if (!te.filters.contains("markdown")) {
      logger.info("adding MarkdownFilter to template engine")
      logger.info(te.filters.toString)
      te.filters += "markdown" -> this
      te.pipelines += "md" -> List(MarkdownFilter)
      te.pipelines += "markdown" -> List(MarkdownFilter)
    }
  }
}
