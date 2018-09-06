resolvers += Classpaths.sbtPluginReleases

addSbtPlugin("org.scoverage" % "sbt-scoverage" % "1.5.1")
addSbtPlugin("com.lucidchart" % "sbt-scalafmt" % "1.15")
addSbtPlugin("com.timushev.sbt" % "sbt-updates" % "0.3.4")
addSbtPlugin("ch.epfl.scala" % "sbt-scalafix" % "0.5.10")

// Following line excludes modules from org.scala-lang when checking plugin updates (See project/project/plugins.sbt).
dependencyUpdatesFilter -= moduleFilter(organization = "org.scala-lang")
