package ac.res.estoril
import org.jsoup.Jsoup
import scala.collection.JavaConverters._

class MarkdownSpec extends Spec {
  feature("Markdown compilation") {
    scenario("compile") {
      val ret = MarkdownFilter.convert("""
# Hello, World!
This is *a Markdown document*!
        """)
      val dom = Jsoup.parseBodyFragment(ret)
      val elems = dom.body.children.asScala.toList
      assert(elems.lengthCompare(2) == 0)
      assert(elems.head.tagName == "h1")
      assert(elems.head.text == "Hello, World!")
      assert(elems(1).tagName == "p")
      assert(elems(1).children.asScala.head.tagName == "em")
      assert(elems(1).children.asScala.head.text == "a Markdown document")
      assert(elems(1).text == "This is a Markdown document!")
    }
  }
}
