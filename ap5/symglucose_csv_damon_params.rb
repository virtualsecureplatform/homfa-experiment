#!/usr/bin/ruby

require "csv"

raise "Usage: #{$0} FILE" unless ARGV.size == 1

in_file = ARGV[0]

cgm = []
first = true
CSV.foreach(in_file) do |row|
  if first
    first = false
    next
  end

  cgm.push row[2].to_f
end

cgm_len = cgm.length
cgm = cgm.sort

printf "10th-percentile threshold %f\n", cgm[cgm_len/10]
printf "90th-percentile threshold %f\n", cgm[cgm_len/10 * 9]
