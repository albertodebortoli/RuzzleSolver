#!/usr/bin/env ruby

require "./ruzzle_solver"
include RuzzleSolver

#if (ARGV.size < 1)
#    puts "Usage:"
#    puts "ruby " + __FILE__ + " <dictionary_file>"
#    exit(0)
#end

RuzzleSolver::run('./dictionaries/botwords_it.txt')
