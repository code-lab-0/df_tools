#!/usr/bin/env scala

import java.lang.System
import java.util.Scanner

object Main extends App {
  for(line <- io.Source.stdin.getLines()) {
    val cols = line.split('\t')
    println(cols(0) + "\t" + cols(1))
  }
}


