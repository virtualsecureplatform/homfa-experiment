#!/usr/bin/ruby

require "sqlite3"
require "numo/gnuplot"
require "stringio"

$export_type = :pdf
#$export_type = :tex

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

def open_db
  SQLite3::Database.new "artificial-dfa.sqlite3"
end

def to_memlogfile(filename)
  raise "invalid filename" unless filename =~ /^(.+)\.log$/
  "#{$1}_mem.log"
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
      mem: [],
    }]
  }.to_h

  logfile_names.each do |logfile_name|
    puts "Processing #{logfile_name}"
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
      # memory
      mem_filename = to_memlogfile(filename)
      File.open(mem_filename).each do |line|
        next unless line =~ /Maximum resident set size \(kbytes\): ([0-9]+)$/
        kbytes = $1.to_i
        data2[logfile_name][:mem].push kbytes
      end
    end
  end

  # dump
  db = open_db
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

      mem_size INTEGER,
      mem_mean REAL,
      mem_stddev REAL,

      PRIMARY KEY (algorithm, state_size, input_size)
    );
  SQL

  data2.each do |filename, data|
    unless filename =~ /^([^_]+)_size-([0-9]+)_size-([0-9]+)bit\.log$/
      $stderr.puts "Regex not match: #{filename}"
    end
    db.execute "INSERT INTO #{table_name} VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
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
               (data[:bs_num] || [0])[0],
               data[:mem].size,
               data[:mem].mean,
               data[:mem].stddev
  end
end

def print_usage_and_exit
  $stderr.puts "Usage: #{$0} import  TABLE-NAME RESULT-DIR"
  $stderr.puts "Usage: #{$0} plot    TABLE-NAME "
  $stderr.puts "Usage: #{$0} tabular TABLE-NAME "
  exit 1
end

def select_from_db(table_name, w: "TRUE", v: [])
  sql = <<"SQL"
SELECT algorithm,state_size,input_size/1000,run_mean/1000000.0,run_stddev/1000000.0,mem_mean/1024.0/1024.0,mem_stddev/1024.0/1024.0
FROM #{table_name}
WHERE #{w}
AND run_mean IS NOT NULL
SQL
  data = {}
  db = open_db
  db.execute(sql, *v).each do |fields|
    algorithm = fields[0]
    data[algorithm] ||= []
    data[algorithm].push(fields[1..])
  end
  data
end

def get_fixed_state_data_from_db(table_name, fixed_state_size)
  data_state = {}
  db = open_db
  db.execute("SELECT algorithm,state_size,input_size/1000,run_mean/1000000.0,run_stddev/1000000.0,mem_mean/1024.0/1024.0,mem_stddev/1024.0/1024.0 FROM #{table_name} WHERE state_size = ? AND run_mean IS NOT NULL", fixed_state_size).each do |fields|
    algorithm = fields[0]
    data_state["#{algorithm}"] ||= []
    data_state["#{algorithm}"].push(fields[1..])
  end
  data_state
end

def get_fixed_input_data_from_db(table_name, fixed_input_size)
  data_input = {}
  db = open_db
  db.execute("SELECT algorithm,state_size,input_size/1000,run_mean/1000000.0,run_stddev/1000000.0,mem_mean/1024.0/1024.0,mem_stddev/1024.0/1024.0 FROM #{table_name} WHERE input_size = ? AND run_mean IS NOT NULL", fixed_input_size).each do |fields|
    algorithm = fields[0]
    data_input["#{algorithm}"] ||= []
    data_input["#{algorithm}"].push(fields[1..])
  end
  data_input
end

def print_tabular(table_name)
  fixed_state_size = 500
  fixed_input_size = 50000
  keys = ["reversed", "bbs-150"]
  titles = ["%ReverseStream", "%BlockStream"]

  data_state = get_fixed_state_data_from_db(table_name, fixed_state_size)
  data_input = get_fixed_input_data_from_db(table_name, fixed_input_size)

  sio = StringIO.new
  sio.puts <<"EOS"
%begin{tabular}{cc|cc}%toprule
Algorithm & %begin{tabular}{@{}c@{}}%# of%%Monitored%%Ciphertexts%end{tabular} & %begin{tabular}{@{}c@{}}Average%%Runtime%%(s)%end{tabular} & %begin{tabular}{@{}c@{}}Average%%Memory%%Usage%%(GiB)%end{tabular}%%
EOS
  keys.each_with_index do |key, ki|
    algorithm = titles[ki]
    sio.puts "%midrule"
    sio.puts "%multirow{#{data_state[key].size}}{*}{#{algorithm}}"
    data_state[key].each_with_index do |fields, index|
      state_size, input_size, run_mean, run_stddev, mem_mean, mem_stddev = fields
      sio.puts " & #{input_size}000 & #{sprintf("%.2f", run_mean)} & #{sprintf("%.2f", mem_mean)}%%"
    end
  end
  sio.puts <<"EOS"
%bottomrule
%end{tabular}
EOS
  puts sio.string.gsub("%", "\\")
  puts

  sio = StringIO.new
  sio.puts <<"EOS"
%begin{tabular}{cc|cc}%toprule
Algorithm & %begin{tabular}{@{}c@{}}%# of%%States%end{tabular} & %begin{tabular}{@{}c@{}}Average%%Runtime%%(s)%end{tabular} & %begin{tabular}{@{}c@{}}Average%%Memory%%Usage%%(GiB)%end{tabular}%%
EOS
  keys.each_with_index do |key, ki|
    algorithm = titles[ki]
    sio.puts "%midrule"
    sio.puts "%multirow{#{data_input[key].size}}{*}{#{algorithm}}"
    data_input[key].each_with_index do |fields, index|
      state_size, input_size, run_mean, run_stddev, mem_mean, mem_stddev = fields
      sio.puts " & #{state_size} & #{sprintf("%.2f", run_mean)} & #{sprintf("%.2f", mem_mean)}%%"
    end
  end
  sio.puts <<"EOS"
%bottomrule
%end{tabular}
EOS
  puts sio.string.gsub("%", "\\")
  puts
end

def print_gnuplot(table_name)
  fixed_state_size = 500
  fixed_input_size = 50000
  yrange_when_fixed_state = "[0:150]"
  yrange_when_fixed_input = "[0:150]"
  term_tikz_size = "8,5"

  data_state = get_fixed_state_data_from_db(table_name, fixed_state_size)
  data_input = get_fixed_input_data_from_db(table_name, fixed_input_size)

  keys = ["reversed", "bbs-150"]
  titles = ["ReverseStream", "BlockStream"]
  #keys = ["offline", "reversed", "bbs-150"]
  #titles = ["Offline", "ReverseStream", "BlockStream"]
  #titles = ["\\Cref{alg:offline}", "\\Cref{alg:reversed}", "\\Cref{alg:bbs}"]
  line_style = [1, 2, 3, 4]
  point_style = [1, 2, 4, 5]

  points_state = []
  keys.each_with_index do |key, index|
    values = data_state[key].map do |state_size, input_size, run_mean, run_stddev, mem_mean, mem_stddev|
      [input_size, run_mean, run_stddev]
    end
    pp data_state[key]
    #points_state.push([
    #  *values.transpose,
    #  with: :errorbars,
    #  notitle: true,
    #  lt: index,
    #  lw: 3,
    #])
    points_state.push([
      *values.transpose,
      with: :linespoints,
      title: titles[index],
      lt: line_style[index],
      lw: 2,
      pt: point_style[index],
      ps: 1,
    ])
  end

  points_input = []
  keys.each_with_index do |key, index|
    values = data_input[key].map do |state_size, input_size, run_mean, run_stddev, mem_mean, mem_stddev|
      [state_size, run_mean, run_stddev]
    end
    #points_input.push([
    #  *values.transpose,
    #  with: :errorbars,
    #  notitle: true,
    #  lt: index,
    #  lw: 2,
    #])
    points_input.push([
      *values.transpose,
      with: :linespoints,
      title: titles[index],
      lt: line_style[index],
      lw: 2,
      pt: point_style[index],
      ps: 1,
    ])
  end

  Numo.gnuplot do
    case $export_type
    when :tex
      set :term, :lua, :tikz
      set :output, "#{table_name}-fixed-state.tex"
      set :term, :tikz, :size, term_tikz_size
    when :pdf
      set :terminal, :pdf, :font, "Helvetica,20"
      set :output, "#{table_name}-fixed-state.pdf"
    end
    set :monochrom
    set :key, :left, :top
    set :key, :Left
    set :xlabel, "Number of Monitored Ciphertexts ($\\times 10^3$)"
    set :ylabel, "time (sec)"
    set :xrange, "[5:55]"
    set :yrange, yrange_when_fixed_state
    set :key, :spacing, 0.9
    plot *points_state
  end

  Numo.gnuplot do
    case $export_type
    when :tex
      set :term, :lua, :tikz
      set :output, "#{table_name}-fixed-input.tex"
      set :term, :tikz, :size, term_tikz_size
    when :pdf
      set :terminal, :pdf, :font, "Helvetica,20"
      set :output, "#{table_name}-fixed-input.pdf"
    end
    set :monochrom
    set :key, :left, :top
    set :key, :Left
    set :xlabel, "Number of States (states)"
    set :ylabel, "time (sec)"
    set :xrange, "[0:510]"
    set :yrange, yrange_when_fixed_input
    set :key, :spacing, 0.9
    plot *points_input
  end
end

print_usage_and_exit unless ARGV.size >= 1

case ARGV[0]
when "import"
  print_usage_and_exit unless ARGV.size == 3
  import_result ARGV[1], ARGV[2]
when "plot"
  print_usage_and_exit unless ARGV.size == 2
  print_gnuplot(ARGV[1])
when "tabular"
  print_tabular(ARGV[1])
else
  print_usage_and_exit
end
