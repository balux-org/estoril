organization := "ac.res"
name := "estoril"

scalaVersion := "2.12.6"
scalacOptions ++= Seq(
  "-deprecation",
  "-encoding",
  "UTF-8",
  "-feature",
  "-Xcheckinit",
  "-Xlint:_"
)

val Log4J2Version = "2.11.1"

libraryDependencies ++= Seq(
  "com.atlassian.commonmark" % "commonmark" % "0.11.0",
  "com.h2database" % "h2" % "1.4.197",
  "com.typesafe.scala-logging" %% "scala-logging" % "3.9.0",
  "com.vladsch.flexmark" % "flexmark" % "0.34.22",
  "commons-codec" % "commons-codec" % "1.11",
  "commons-io" % "commons-io" % "2.6",
  "io.circe" %% "circe-core" % "0.9.3",
  "io.circe" %% "circe-generic" % "0.9.3",
  "io.circe" %% "circe-parser" % "0.9.3",
  "net.jcazevedo" %% "moultingyaml" % "0.4.0",
  "org.apache.httpcomponents" % "httpclient" % "4.5.6",
  "org.apache.logging.log4j" % "log4j-api" % Log4J2Version,
  "org.apache.logging.log4j" % "log4j-core" % Log4J2Version % Optional,
  "org.apache.logging.log4j" % "log4j-web" % Log4J2Version % Optional,
  "org.apache.logging.log4j" % "log4j-slf4j-impl" % Log4J2Version % Optional,
  "org.eclipse.jgit" % "org.eclipse.jgit" % "5.0.2.201807311906-r",
  "org.scalactic" %% "scalactic" % "3.0.5",
  "org.jsoup" % "jsoup" % "1.11.3",
  "org.scalatra.scalate" %% "scalate-core" % "1.8.0",
  "org.slf4j" % "slf4j-api" % "1.7.25",
  "org.spire-math" %% "jawn-ast" % "0.13.0",
  "org.spire-math" %% "jawn-parser" % "0.13.0",
  "org.yaml" % "snakeyaml" % "1.23",
  "org.scalamock" %% "scalamock-scalatest-support" % "3.6.0" % Test,
  "org.scalatest" %% "scalatest" % "3.0.5" % Test
)

testOptions in Test += Tests.Argument(TestFrameworks.ScalaTest, "-e")

addCompilerPlugin("org.psywerx.hairyfotr" %% "linter" % "0.1.17")

scalafixSemanticdbVersion := "4.0.0-M9"

// publish to dist/maven in Maven style.
// After publishing, we rsync the generated files to our remote Maven repository.
// Note that SBT cannot resolve a local Maven repository.
// We need to access it via HTTP(S).
publishTo := Some(Resolver.file("dist-maven", file("dist/maven")))
