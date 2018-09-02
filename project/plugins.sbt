resolvers += Classpaths.sbtPluginReleases

addSbtPlugin("org.scoverage" % "sbt-scoverage" % "1.5.1")
addSbtPlugin("org.scalariform" % "sbt-scalariform" % "1.8.2")
addSbtPlugin("com.timushev.sbt" % "sbt-updates" % "0.3.4")
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.7")

// Following line excludes modules from org.scala-lang when checking plugin updates (See project/project/plugins.sbt).
dependencyUpdatesFilter -= moduleFilter(organization = "org.scala-lang")
