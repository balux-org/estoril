organization := "nu.u8"
name := "estoril"

scalaVersion := "2.12.1"
scalacOptions ++= Seq(
  "-deprecation",
  "-encoding", "UTF-8",
  "-feature",
  "-opt:l:classpath",
  "-opt-warnings:_",
  "-Xcheckinit",
  "-Xlint:_"
)

libraryDependencies ++= Seq(
  "com.atlassian.commonmark" % "commonmark" % "0.8.0",
  "com.h2database" % "h2" % "1.4.193",
  "com.typesafe.scala-logging" % "scala-logging_2.12" % "3.5.0",
  "commons-codec" % "commons-codec" % "1.10",
  "commons-io" % "commons-io" % "2.5",
  "io.circe" %% "circe-core" % "0.6.1",
  "io.circe" %% "circe-generic" % "0.6.1",
  "io.circe" %% "circe-parser" % "0.6.1",
  "net.jcazevedo" %% "moultingyaml" % "0.4.0",
  "org.apache.httpcomponents" % "httpclient" % "4.5.2",
  "org.eclipse.jgit" % "org.eclipse.jgit" % "4.5.0.201609210915-r",
  "org.scalactic" %% "scalactic" % "3.0.1",
  "org.scalatra.scalate" %% "scalate-core" % "1.8.0",
  "org.slf4j" % "slf4j-api" % "1.7.22",
  "org.spire-math" %% "jawn-ast" % "0.10.4",
  "org.spire-math" %% "jawn-parser" % "0.10.4",
  "org.yaml" % "snakeyaml" % "1.17",
  "ch.qos.logback" % "logback-classic" % "1.1.8" % Optional,
  "org.scalamock" %% "scalamock-scalatest-support" % "3.4.2" % Test,
  "org.scalatest" %% "scalatest" % "3.0.1" % Test)

testOptions in Test += Tests.Argument(TestFrameworks.ScalaTest, "-e")

addCompilerPlugin("org.psywerx.hairyfotr" %% "linter" % "0.1.17")

// publish to dist/maven in Maven style.
// After publishing, we rsync the generated files to our remote Maven repository.
// Note that SBT cannot resolve a local Maven repository.
// We need to access it via HTTP(S).
publishTo := Some(Resolver.file("dist-maven", file("dist/maven")))

mainClass in assembly := Some("nu.u8.estoril.Generate")

