#!/usr/bin/ruby

require "csv"

def print_bits(v, num_digits)
  0.upto(num_digits - 1) do |i|
    print((v & (1 << i) != 0) ? 1 : 0)
  end
end

raise "Usage: #{$0} [bg] FILE" unless ARGV.size == 2

subcommand = ARGV[0]
in_file = ARGV[1]

case subcommand
when "bg"
  first = true
  cnt = 0
  cnt_enable = false
  CSV.foreach(in_file) do |row|
    if first
      first = false
      next
    end

    v = row[2].to_i
    print_bits(v, 9)
  end
end
#when "dbg"
#  first = true
#  prev = nil
#  CSV.foreach(in_file) do |row|
#    if first
#      first = false
#      next
#    end
#    if prev.nil?
#      prev = row[2].to_f
#      next
#    end
#
#    v = 32 + hist(row[2].to_f - prev, min: -32, max: 31, step: 1)
#    print_bits(v, 6)
#    #$stderr.puts "#{row[2].to_f - prev}\t#{v - 16}"
#    prev = row[2].to_f
#  end
#end
