#!/usr/bin/ruby

def print_bits(v, num_digits)
  0.upto(num_digits - 1) do |i|
    print((v & (1 << i) != 0) ? 1 : 0)
  end
end

raise "Usage: #{$0} [true|false] COL_NUM" unless ARGV.size == 2

subcommand = ARGV[0]
num = ARGV[1].to_i

srand(0)
idx = 0

case subcommand
when "true" then
  while idx < num
    for cnt in 0..22 do
      v = rand(196..511)
      print_bits(v, 9)
      idx = idx + 1
    end
    v = rand(0..195)
    print_bits(v, 9)
    idx = idx + 1
  end
when "false" then
  while idx < num
    for cnt in 0..25 do
      v = rand(196..511)
      print_bits(v, 9)
      idx = idx + 1
    end
    v = rand(0..195)
    print_bits(v, 9)
    idx = idx + 1
  end
end
