#!/usr/bin/env scala 

object Main extends App {
  for(line <- io.Source.stdin.getLines()) {
    val cols = line.split('\t')
	println(cols.size)
    //println(cols(0) + "\t" + cols(1))
  }
}




