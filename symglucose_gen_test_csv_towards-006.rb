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

raise "Usage: #{$0} [true|false] COL_NUM" unless ARGV.size == 2

subcommand = ARGV[0]
num = ARGV[1].to_i

threshold = 63

idx = 0

# dt = 30
case subcommand
when "true" then
  while idx < num
    if idx < 7 or idx > 20
      v = hist(40.0, min: 0, max: 31, step: 10)
      print_bits(v, 5)
      idx = idx + 1
    end
    for i in 0..4 do
      v = hist(40.0, min: 0, max: 31, step: 10)
      print_bits(v, 5)
      idx = idx + 1
    end
    v = hist(90.0, min: 0, max: 31, step: 10)
    print_bits(v, 5)
    idx = idx + 1
  end
when "false" then
  while idx < num
    if idx < 7 or idx > 20
      v = hist(40.0, min: 0, max: 31, step: 10)
      print_bits(v, 5)
      idx = idx + 1
    end
    for i in 0..5 do
      v = hist(40.0, min: 0, max: 31, step: 10)
      print_bits(v, 5)
      idx = idx + 1
    end
    v = hist(90.0, min: 0, max: 31, step: 10)
    print_bits(v, 5)
    idx = idx + 1
  end
end
