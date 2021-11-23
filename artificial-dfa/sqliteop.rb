#!/usr/bin/ruby

require "sqlite3"

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

def import_result(table_name, result_dir)
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

  data2 = logfile_names.map { |filename|
    [filename, { enc_sum: [], run_sum: [], dec_sum: [] }]
  }.to_h

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
    end
  end

  # dump
  db = SQLite3::Database.new "artificial-dfa.sqlite3"
  db.execute <<-SQL
    CREATE TABLE #{table_name} (
      algorithm TEXT,
      state_size INTEGER,
      input_size INTEGER,
      enc_size INTEGER,
      enc_mean INTEGER,
      enc_stddev REAL,
      run_size INTEGER,
      run_mean INTEGER,
      run_stddev REAL,
      dec_size INTEGER,
      dec_mean INTEGER,
      dec_stddev REAL,
      PRIMARY KEY (algorithm, state_size, input_size)
    );
  SQL

  data2.each do |filename, data|
    unless filename =~ /^([^_]+)_size-([0-9]+)_size-([0-9]+)bit\.log$/
      $stderr.puts "Regex not match: #{filename}"
    end
    db.execute "INSERT INTO #{table_name} VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
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
               data[:dec_sum].stddev
  end
end

def print_usage_and_exit
  $stderr.puts "Usage: #{$0} import TABLE-NAME RESULT-DIR"
  exit 1
end

print_usage_and_exit unless ARGV.size >= 1

case ARGV[0]
when "import"
  print_usage_and_exit unless ARGV.size == 3
  import_result ARGV[1], ARGV[2]
else
  print_usage_and_exit
end
