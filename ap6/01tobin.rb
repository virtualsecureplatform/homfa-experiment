#!/usr/bin/ruby

raise "#{$0} NUM-AP" unless ARGV.size == 1
num_ap = ARGV[0].to_i

byte = 0
cnt = 0
$stdin.each_char do |c|
  raise "Not 0 or 1" unless c == "1" or c == "0"
  byte |= c.to_i << (cnt % 8)

  cnt += 1
  if cnt == num_ap
    print byte.chr
    byte = 0
    cnt = 0
  elsif cnt % 8 == 0
    print byte.chr
    byte = 0
  end
end
raise "Not implemented! Currently, data size must be divided by 8" unless cnt % 8 == 0
