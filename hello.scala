#!/usr/bin/env scalas

/***
scalaVersion := "2.11.7"
*/

println("Hello " + args.toList.headOption.getOrElse("World"))

