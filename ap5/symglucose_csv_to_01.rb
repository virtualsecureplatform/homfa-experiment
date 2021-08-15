#!/usr/bin/ruby

require "csv"

def hist(value, origin: 0, min:, max:, step:)
  v = ((value - origin) / step).to_i
  if v > max
    max
  elsif v < min
    min
  else
    v
  end
end

def print_bits(v, num_digits)
  0.upto(num_digits - 1) do |i|
    print((v & (1 << i) != 0) ? 1 : 0)
  end
end

raise "Usage: #{$0} [bg|dbg] FILE" unless ARGV.size == 2

subcommand = ARGV[0]
in_file = ARGV[1]

case subcommand
when "bg"
  first = true
  CSV.foreach(in_file) do |row|
    if first
      first = false
      next
    end

    v = hist(row[2].to_f, min: 0, max: 63, step: 10)
    print_bits(v, 6)
  end
when "dbg"
  first = true
  prev = nil
  CSV.foreach(in_file) do |row|
    if first
      first = false
      next
    end
    if prev.nil?
      prev = row[2].to_f
      next
    end

    v = 16 + hist(row[2].to_f - prev, min: -16, max: 15, step: 1)
    print_bits(v, 5)
    #$stderr.puts "#{row[2].to_f - prev}\t#{v - 16}"
    prev = row[2].to_f
  end
end
