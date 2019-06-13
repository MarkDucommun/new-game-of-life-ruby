require 'benchmark'
require_relative '../sort_set'

max = 1000000

range = (1..max)

to_insert = range
              .map { |i| rand(4).times { i } }
              .flatten
              .shuffle!

set = SortSet.new 100

puts Benchmark.measure { to_insert.each { |i| set.add i } }

puts Benchmark.measure { range.each { |i| set.find i } }
