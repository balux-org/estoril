resolvers += Classpaths.sbtPluginReleases
addSbtPlugin("org.scoverage" % "sbt-scoverage" % "1.5.0")
addSbtPlugin("org.scalariform" % "sbt-scalariform" % "1.6.0")
addSbtPlugin("com.timushev.sbt" % "sbt-updates" % "0.3.0")

// for `sbt "reload plugins" "dependencyUpdates" "reload return"
dependencyUpdatesExclusions := moduleFilter(organization = "org.scala-lang")
