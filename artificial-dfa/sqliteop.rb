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
    "bbs-100_size-0050_size-10000bit.log",
    "bbs-100_size-0050_size-20000bit.log",
    "bbs-100_size-0050_size-30000bit.log",
    "bbs-100_size-0050_size-40000bit.log",
    "bbs-100_size-0050_size-50000bit.log",
    "bbs-100_size-0100_size-10000bit.log",
    "bbs-100_size-0100_size-20000bit.log",
    "bbs-100_size-0100_size-30000bit.log",
    "bbs-100_size-0100_size-40000bit.log",
    "bbs-100_size-0100_size-50000bit.log",
    "bbs-100_size-0200_size-10000bit.log",
    "bbs-100_size-0200_size-20000bit.log",
    "bbs-100_size-0200_size-30000bit.log",
    "bbs-100_size-0200_size-40000bit.log",
    "bbs-100_size-0200_size-50000bit.log",
    "bbs-100_size-0300_size-10000bit.log",
    "bbs-100_size-0300_size-20000bit.log",
    "bbs-100_size-0300_size-30000bit.log",
    "bbs-100_size-0300_size-40000bit.log",
    "bbs-100_size-0300_size-50000bit.log",
    "bbs-100_size-0400_size-10000bit.log",
    "bbs-100_size-0400_size-20000bit.log",
    "bbs-100_size-0400_size-30000bit.log",
    "bbs-100_size-0400_size-40000bit.log",
    "bbs-100_size-0400_size-50000bit.log",
    "bbs-100_size-0500_size-10000bit.log",
    "bbs-100_size-0500_size-20000bit.log",
    "bbs-100_size-0500_size-30000bit.log",
    "bbs-100_size-0500_size-40000bit.log",
    "bbs-100_size-0500_size-50000bit.log",
    "bbs-150_size-0010_size-10000bit.log",
    "bbs-150_size-0010_size-20000bit.log",
    "bbs-150_size-0010_size-30000bit.log",
    "bbs-150_size-0010_size-40000bit.log",
    "bbs-150_size-0010_size-50000bit.log",
    "bbs-150_size-0050_size-10000bit.log",
    "bbs-150_size-0050_size-20000bit.log",
    "bbs-150_size-0050_size-30000bit.log",
    "bbs-150_size-0050_size-40000bit.log",
    "bbs-150_size-0050_size-50000bit.log",
    "bbs-150_size-0100_size-10000bit.log",
    "bbs-150_size-0100_size-20000bit.log",
    "bbs-150_size-0100_size-30000bit.log",
    "bbs-150_size-0100_size-40000bit.log",
    "bbs-150_size-0100_size-50000bit.log",
    "bbs-150_size-0200_size-10000bit.log",
    "bbs-150_size-0200_size-20000bit.log",
    "bbs-150_size-0200_size-30000bit.log",
    "bbs-150_size-0200_size-40000bit.log",
    "bbs-150_size-0200_size-50000bit.log",
    "bbs-150_size-0300_size-10000bit.log",
    "bbs-150_size-0300_size-20000bit.log",
    "bbs-150_size-0300_size-30000bit.log",
    "bbs-150_size-0300_size-40000bit.log",
    "bbs-150_size-0300_size-50000bit.log",
    "bbs-150_size-0400_size-10000bit.log",
    "bbs-150_size-0400_size-20000bit.log",
    "bbs-150_size-0400_size-30000bit.log",
    "bbs-150_size-0400_size-40000bit.log",
    "bbs-150_size-0400_size-50000bit.log",
    "bbs-150_size-0500_size-10000bit.log",
    "bbs-150_size-0500_size-20000bit.log",
    "bbs-150_size-0500_size-30000bit.log",
    "bbs-150_size-0500_size-40000bit.log",
    "bbs-150_size-0500_size-50000bit.log",
    "bbs-50_size-0010_size-10000bit.log",
    "bbs-50_size-0010_size-20000bit.log",
    "bbs-50_size-0010_size-30000bit.log",
    "bbs-50_size-0010_size-40000bit.log",
    "bbs-50_size-0010_size-50000bit.log",
    "bbs-50_size-0050_size-10000bit.log",
    "bbs-50_size-0050_size-20000bit.log",
    "bbs-50_size-0050_size-30000bit.log",
    "bbs-50_size-0050_size-40000bit.log",
    "bbs-50_size-0050_size-50000bit.log",
    "bbs-50_size-0100_size-10000bit.log",
    "bbs-50_size-0100_size-20000bit.log",
    "bbs-50_size-0100_size-30000bit.log",
    "bbs-50_size-0100_size-40000bit.log",
    "bbs-50_size-0100_size-50000bit.log",
    "bbs-50_size-0200_size-10000bit.log",
    "bbs-50_size-0200_size-20000bit.log",
    "bbs-50_size-0200_size-30000bit.log",
    "bbs-50_size-0200_size-40000bit.log",
    "bbs-50_size-0200_size-50000bit.log",
    "bbs-50_size-0300_size-10000bit.log",
    "bbs-50_size-0300_size-20000bit.log",
    "bbs-50_size-0300_size-30000bit.log",
    "bbs-50_size-0300_size-40000bit.log",
    "bbs-50_size-0300_size-50000bit.log",
    "bbs-50_size-0400_size-10000bit.log",
    "bbs-50_size-0400_size-20000bit.log",
    "bbs-50_size-0400_size-30000bit.log",
    "bbs-50_size-0400_size-40000bit.log",
    "bbs-50_size-0400_size-50000bit.log",
    "bbs-50_size-0500_size-10000bit.log",
    "bbs-50_size-0500_size-20000bit.log",
    "bbs-50_size-0500_size-30000bit.log",
    "bbs-50_size-0500_size-40000bit.log",
    "bbs-50_size-0500_size-50000bit.log",
    "offline_size-0010_size-10000bit.log",
    "offline_size-0010_size-20000bit.log",
    "offline_size-0010_size-30000bit.log",
    "offline_size-0010_size-40000bit.log",
    "offline_size-0010_size-50000bit.log",
    "offline_size-0050_size-10000bit.log",
    "offline_size-0050_size-20000bit.log",
    "offline_size-0050_size-30000bit.log",
    "offline_size-0050_size-40000bit.log",
    "offline_size-0050_size-50000bit.log",
    "offline_size-0100_size-10000bit.log",
    "offline_size-0100_size-20000bit.log",
    "offline_size-0100_size-30000bit.log",
    "offline_size-0100_size-40000bit.log",
    "offline_size-0100_size-50000bit.log",
    "offline_size-0200_size-10000bit.log",
    "offline_size-0200_size-20000bit.log",
    "offline_size-0200_size-30000bit.log",
    "offline_size-0200_size-40000bit.log",
    "offline_size-0200_size-50000bit.log",
    "offline_size-0300_size-10000bit.log",
    "offline_size-0300_size-20000bit.log",
    "offline_size-0300_size-30000bit.log",
    "offline_size-0300_size-40000bit.log",
    "offline_size-0300_size-50000bit.log",
    "offline_size-0400_size-10000bit.log",
    "offline_size-0400_size-20000bit.log",
    "offline_size-0400_size-30000bit.log",
    "offline_size-0400_size-40000bit.log",
    "offline_size-0400_size-50000bit.log",
    "offline_size-0500_size-10000bit.log",
    "offline_size-0500_size-20000bit.log",
    "offline_size-0500_size-30000bit.log",
    "offline_size-0500_size-40000bit.log",
    "offline_size-0500_size-50000bit.log",
    "plain_size-0010_size-10000bit.log",
    "plain_size-0010_size-20000bit.log",
    "plain_size-0010_size-30000bit.log",
    "plain_size-0010_size-40000bit.log",
    "plain_size-0010_size-50000bit.log",
    "plain_size-0050_size-10000bit.log",
    "plain_size-0050_size-20000bit.log",
    "plain_size-0050_size-30000bit.log",
    "plain_size-0050_size-40000bit.log",
    "plain_size-0050_size-50000bit.log",
    "plain_size-0100_size-10000bit.log",
    "plain_size-0100_size-20000bit.log",
    "plain_size-0100_size-30000bit.log",
    "plain_size-0100_size-40000bit.log",
    "plain_size-0100_size-50000bit.log",
    "plain_size-0200_size-10000bit.log",
    "plain_size-0200_size-20000bit.log",
    "plain_size-0200_size-30000bit.log",
    "plain_size-0200_size-40000bit.log",
    "plain_size-0200_size-50000bit.log",
    "plain_size-0300_size-10000bit.log",
    "plain_size-0300_size-20000bit.log",
    "plain_size-0300_size-30000bit.log",
    "plain_size-0300_size-40000bit.log",
    "plain_size-0300_size-50000bit.log",
    "plain_size-0400_size-10000bit.log",
    "plain_size-0400_size-20000bit.log",
    "plain_size-0400_size-30000bit.log",
    "plain_size-0400_size-40000bit.log",
    "plain_size-0400_size-50000bit.log",
    "plain_size-0500_size-10000bit.log",
    "plain_size-0500_size-20000bit.log",
    "plain_size-0500_size-30000bit.log",
    "plain_size-0500_size-40000bit.log",
    "plain_size-0500_size-50000bit.log",
    "reversed_size-0010_size-10000bit.log",
    "reversed_size-0010_size-20000bit.log",
    "reversed_size-0010_size-30000bit.log",
    "reversed_size-0010_size-40000bit.log",
    "reversed_size-0010_size-50000bit.log",
    "reversed_size-0050_size-10000bit.log",
    "reversed_size-0050_size-20000bit.log",
    "reversed_size-0050_size-30000bit.log",
    "reversed_size-0050_size-40000bit.log",
    "reversed_size-0050_size-50000bit.log",
    "reversed_size-0100_size-10000bit.log",
    "reversed_size-0100_size-20000bit.log",
    "reversed_size-0100_size-30000bit.log",
    "reversed_size-0100_size-40000bit.log",
    "reversed_size-0100_size-50000bit.log",
    "reversed_size-0200_size-10000bit.log",
    "reversed_size-0200_size-20000bit.log",
    "reversed_size-0200_size-30000bit.log",
    "reversed_size-0200_size-40000bit.log",
    "reversed_size-0200_size-50000bit.log",
    "reversed_size-0300_size-10000bit.log",
    "reversed_size-0300_size-20000bit.log",
    "reversed_size-0300_size-30000bit.log",
    "reversed_size-0300_size-40000bit.log",
    "reversed_size-0300_size-50000bit.log",
    "reversed_size-0400_size-10000bit.log",
    "reversed_size-0400_size-20000bit.log",
    "reversed_size-0400_size-30000bit.log",
    "reversed_size-0400_size-40000bit.log",
    "reversed_size-0400_size-50000bit.log",
    "reversed_size-0500_size-10000bit.log",
    "reversed_size-0500_size-20000bit.log",
    "reversed_size-0500_size-30000bit.log",
    "reversed_size-0500_size-40000bit.log",
    "reversed_size-0500_size-50000bit.log",
  ]

  data2 = logfile_names.map { |filename|
    [filename, {
      enc_sum: [],
      run_sum: [],
      dec_sum: [],
      cb_sum: [],
      cb_num: [],
      cmux_sum: [],
      cmux_num: [],
      bs_sum: [],
      bs_num: [],
    }]
  }.to_h

  logfile_names.each do |logfile_name|
    Dir.glob(File.join(result_dir, "**", logfile_name)).each do |filename|
      data = {
        enc: [],
        run: [],
        dec: [],
      }
      File.open(filename).each do |line|
        fields = line.split(",")
        kind_sym = fields[0].to_sym
        case kind_sym
        when :enc, :run, :dec
          data[kind_sym].push fields[1].to_i
        when :"time_recorder-circuit_bootstrapping"
          data2[logfile_name][:cb_sum].push fields[2].to_i
          data2[logfile_name][:cb_num].push fields[1].to_i
        when :"time_recorder-cmux"
          data2[logfile_name][:cmux_sum].push fields[2].to_i
          data2[logfile_name][:cmux_num].push fields[1].to_i
        when :"time_recorder-bootstrapping"
          data2[logfile_name][:bs_sum].push fields[2].to_i
          data2[logfile_name][:bs_num].push fields[1].to_i
        end
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

      cb_sum_size INTEGER,
      cb_sum_mean INTEGER,
      cb_sum_stddev REAL,
      cb_num INTEGER,

      cmux_sum_size INTEGER,
      cmux_sum_mean INTEGER,
      cmux_sum_stddev REAL,
      cmux_num INTEGER,

      bs_sum_size INTEGER,
      bs_sum_mean INTEGER,
      bs_sum_stddev REAL,
      bs_num INTEGER,

      PRIMARY KEY (algorithm, state_size, input_size)
    );
  SQL

  data2.each do |filename, data|
    unless filename =~ /^([^_]+)_size-([0-9]+)_size-([0-9]+)bit\.log$/
      $stderr.puts "Regex not match: #{filename}"
    end
    db.execute "INSERT INTO #{table_name} VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
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
               data[:dec_sum].stddev,
               data[:cb_sum].size,
               data[:cb_sum].mean,
               data[:cb_sum].stddev,
               (data[:cb_num] || [0])[0],
               data[:cmux_sum].size,
               data[:cmux_sum].mean,
               data[:cmux_sum].stddev,
               (data[:cmux_num] || [0])[0],
               data[:bs_sum].size,
               data[:bs_sum].mean,
               data[:bs_sum].stddev,
               (data[:bs_num] || [0])[0]
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
