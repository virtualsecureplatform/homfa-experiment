#!/usr/bin/ruby

require "csv"

raise "Usage: #{$0} IN_FILE1 OUT_FILE1 OUT_FILE2" unless ARGV.size == 3

in_file = ARGV[0]
out_file1 = ARGV[1]
out_file2 = ARGV[2]

cgm = []
first = true
first_row = nil
CSV.foreach(in_file) do |row|
  if first
    first_row = row
    first = false
    next
  end

  cgm.push row
end

cgm_len = cgm.length
cgm_first = cgm[0..cgm_len/2]
cgm_latter = cgm[cgm_len/2..cgm_len]

CSV.open(out_file1, "wb") do |csv|
  csv << first_row
  cgm_first.each do |v|
    csv << v
  end
end

CSV.open(out_file2, "wb") do |csv|
  csv << first_row
  cgm_latter.each do |v|
    csv << v
  end
end
