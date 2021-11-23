#!/usr/bin/ruby

require "stringio"
require "csv"
require "byebug"

module Enumerable
  def sum
    inject(0) do |acc, i|
      acc + i
    end
  end

  def mean
    sum / length.to_f
  end

  def var
    m = mean
    s = inject(0) do |acc, i|
      acc + (i - m) ** 2
    end
    s / (length - 1).to_f
  end

  def stddev
    Math.sqrt(var)
  end
end

raise "#{$0} RESULT-DIR" unless ARGV.size == 1
result_dir = ARGV[0]

logfile_names = [
  "bbs-100_size-0010_size-10000bit.log",
  "bbs-100_size-0010_size-20000bit.log",
  "bbs-100_size-0010_size-30000bit.log",
  "bbs-100_size-0010_size-40000bit.log",
  "bbs-100_size-0010_size-50000bit.log",
  "bbs-100_size-0100_size-10000bit.log",
  "bbs-100_size-0100_size-20000bit.log",
  "bbs-100_size-0100_size-30000bit.log",
  "bbs-100_size-0100_size-40000bit.log",
  "bbs-100_size-0100_size-50000bit.log",
  "bbs-100_size-0500_size-10000bit.log",
  "bbs-100_size-0500_size-20000bit.log",
  "bbs-100_size-0500_size-30000bit.log",
  "bbs-100_size-0500_size-40000bit.log",
  "bbs-100_size-0500_size-50000bit.log",
  "bbs-100_size-1000_size-10000bit.log",
  "bbs-100_size-1000_size-20000bit.log",
  "bbs-100_size-1000_size-30000bit.log",
  "bbs-100_size-1000_size-40000bit.log",
  "bbs-100_size-1000_size-50000bit.log",
  "bbs-150_size-0010_size-10000bit.log",
  "bbs-150_size-0010_size-20000bit.log",
  "bbs-150_size-0010_size-30000bit.log",
  "bbs-150_size-0010_size-40000bit.log",
  "bbs-150_size-0010_size-50000bit.log",
  "bbs-150_size-0100_size-10000bit.log",
  "bbs-150_size-0100_size-20000bit.log",
  "bbs-150_size-0100_size-30000bit.log",
  "bbs-150_size-0100_size-40000bit.log",
  "bbs-150_size-0100_size-50000bit.log",
  "bbs-150_size-0500_size-10000bit.log",
  "bbs-150_size-0500_size-20000bit.log",
  "bbs-150_size-0500_size-30000bit.log",
  "bbs-150_size-0500_size-40000bit.log",
  "bbs-150_size-0500_size-50000bit.log",
  "bbs-150_size-1000_size-10000bit.log",
  "bbs-150_size-1000_size-20000bit.log",
  "bbs-150_size-1000_size-30000bit.log",
  "bbs-150_size-1000_size-40000bit.log",
  "bbs-150_size-1000_size-50000bit.log",
  "bbs-50_size-0010_size-10000bit.log",
  "bbs-50_size-0010_size-20000bit.log",
  "bbs-50_size-0010_size-30000bit.log",
  "bbs-50_size-0010_size-40000bit.log",
  "bbs-50_size-0010_size-50000bit.log",
  "bbs-50_size-0100_size-10000bit.log",
  "bbs-50_size-0100_size-20000bit.log",
  "bbs-50_size-0100_size-30000bit.log",
  "bbs-50_size-0100_size-40000bit.log",
  "bbs-50_size-0100_size-50000bit.log",
  "bbs-50_size-0500_size-10000bit.log",
  "bbs-50_size-0500_size-20000bit.log",
  "bbs-50_size-0500_size-30000bit.log",
  "bbs-50_size-0500_size-40000bit.log",
  "bbs-50_size-0500_size-50000bit.log",
  "bbs-50_size-1000_size-10000bit.log",
  "bbs-50_size-1000_size-20000bit.log",
  "bbs-50_size-1000_size-30000bit.log",
  "bbs-50_size-1000_size-40000bit.log",
  "bbs-50_size-1000_size-50000bit.log",
  "offline_size-0010_size-10000bit.log",
  "offline_size-0010_size-20000bit.log",
  "offline_size-0010_size-30000bit.log",
  "offline_size-0010_size-40000bit.log",
  "offline_size-0010_size-50000bit.log",
  "offline_size-0100_size-10000bit.log",
  "offline_size-0100_size-20000bit.log",
  "offline_size-0100_size-30000bit.log",
  "offline_size-0100_size-40000bit.log",
  "offline_size-0100_size-50000bit.log",
  "offline_size-0500_size-10000bit.log",
  "offline_size-0500_size-20000bit.log",
  "offline_size-0500_size-30000bit.log",
  "offline_size-0500_size-40000bit.log",
  "offline_size-0500_size-50000bit.log",
  "offline_size-1000_size-10000bit.log",
  "offline_size-1000_size-20000bit.log",
  "offline_size-1000_size-30000bit.log",
  "offline_size-1000_size-40000bit.log",
  "offline_size-1000_size-50000bit.log",
  "reversed_size-0010_size-10000bit.log",
  "reversed_size-0010_size-20000bit.log",
  "reversed_size-0010_size-30000bit.log",
  "reversed_size-0010_size-40000bit.log",
  "reversed_size-0010_size-50000bit.log",
  "reversed_size-0100_size-10000bit.log",
  "reversed_size-0100_size-20000bit.log",
  "reversed_size-0100_size-30000bit.log",
  "reversed_size-0100_size-40000bit.log",
  "reversed_size-0100_size-50000bit.log",
  "reversed_size-0500_size-10000bit.log",
  "reversed_size-0500_size-20000bit.log",
  "reversed_size-0500_size-30000bit.log",
  "reversed_size-0500_size-40000bit.log",
  "reversed_size-0500_size-50000bit.log",
  "reversed_size-1000_size-10000bit.log",
  "reversed_size-1000_size-20000bit.log",
  "reversed_size-1000_size-30000bit.log",
  "reversed_size-1000_size-40000bit.log",
  "reversed_size-1000_size-50000bit.log",
]

data2 = logfile_names.map { |filename| [filename, { enc_sum: [], run_sum: [], dec_sum: [] }] }.to_h

sio1 = StringIO.new
CSV(sio1) do |csv|
  csv << ["filename", "enc_size", "enc_sum", "enc_mean", "enc_stddev", "run_size", "run_sum", "run_mean", "run_stddev", "dec_size", "dec_sum", "dec_mean", "dec_stddev"]
  logfile_names.each do |logfile_name|
    Dir.glob(File.join(result_dir, "**", logfile_name)).each do |filename|
      data = {
        enc: [],
        run: [],
        dec: [],
      }
      File.open(filename).each do |line|
        kind, elapsed = line.split(",")
        kind_sym = kind.to_sym
        next unless data.key? kind_sym
        data[kind_sym].push elapsed.to_i
      end
      data2[logfile_name][:enc_sum].push data[:enc].sum
      data2[logfile_name][:run_sum].push data[:run].sum
      data2[logfile_name][:dec_sum].push data[:dec].sum

      csv << [filename,
              data[:enc].size,
              data[:enc].sum,
              data[:enc].mean,
              data[:enc].stddev,
              data[:run].size,
              data[:run].sum,
              data[:run].mean,
              data[:run].stddev,
              data[:dec].size,
              data[:dec].sum,
              data[:dec].mean,
              data[:dec].stddev]
    end
  end
end

sio2 = StringIO.new
CSV(sio2) do |csv|
  csv << ["logfile_name", "algorithm", "state_size", "input_size", "enc_size", "enc_mean", "enc_stddev", "run_size", "run_mean", "run_stddev", "dec_size", "dec_mean", "dec_stddev"]
  data2.each do |filename, data|
    unless filename =~ /^([^_]+)_size-([0-9]+)_size-([0-9]+)bit\.log$/
      $stderr.puts "Regex not match: #{filename}"
    end
    csv << [filename,
            $1,
            $2.to_i,
            $3.to_i,
            data[:enc_sum].size,
            data[:enc_sum].mean,
            data[:enc_sum].stddev,
            data[:run_sum].size,
            data[:run_sum].mean,
            data[:run_sum].stddev,
            data[:dec_sum].size,
            data[:dec_sum].mean,
            data[:dec_sum].stddev]
  end
end

#puts
puts sio2.string
#puts sio1.string
