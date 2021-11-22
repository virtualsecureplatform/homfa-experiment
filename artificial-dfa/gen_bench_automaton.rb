#!/usr/bin/ruby

raise "Usage: #{$0} NUM-STATES" unless ARGV.size == 1

num_states = ARGV[0].to_i
raise "NUM-STATES must be greater than 1" if num_states <= 1

puts num_states
puts "0*\t0\t1"
(1...num_states - 1).each do |i|
  puts "#{i}\t#{i}\t#{i + 1}"
end
puts "#{num_states - 1}\t#{num_states - 1}\t0"
