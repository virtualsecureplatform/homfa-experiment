#!/usr/bin/ruby

# for plot: gnuplot -e 'set term lua tikz createstyle'

require "sqlite3"
require "numo/gnuplot"
require "stringio"
require "csv"

#$export_type = :pdf
$export_type = :tex

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

def format_float(val)
  if val.nil?
    "---"
  else
    sprintf("%.2f", val)
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
SELECT
  algorithm,
  state_size,
  input_size/1000,
  run_mean/1000000.0,
  run_stddev/1000000.0,
  mem_mean/1024.0/1024.0,
  mem_stddev/1024.0/1024.0,
  cmux_sum_mean/1000000.0,
  bs_sum_mean/1000000.0,
  cb_sum_mean/1000000.0
FROM #{table_name}
WHERE #{w}
AND run_mean IS NOT NULL
SQL
  data = {}
  db = open_db
  db.execute(sql, *v).each do |fields|
    algorithm = fields[0]
    h =
      [
        :algorithm,
        :state_size,
        :input_size,
        :run_mean,
        :run_stddev,
        :mem_mean,
        :mem_stddev,
        :cmux_sum_mean,
        :bs_sum_mean,
        :cb_sum_mean,
      ].zip(fields).to_h
    data[algorithm] ||= []
    data[algorithm].push(h)
  end
  data
end

def get_fixed_state_data_from_db(table_name, fixed_state_size)
  select_from_db table_name, w: "state_size = ?", v: [fixed_state_size]
end

def get_fixed_input_data_from_db(table_name, fixed_input_size)
  select_from_db table_name, w: "input_size = ?", v: [fixed_input_size]
end

def print_tabular(table_name)
  fixed_state_size = 500
  fixed_input_size = 50000
  algorithm_keys = ["reversed", "bbs-150"]
  titles = ["%ReverseStream", "%BlockStream"]
  data_src = {
    state_fixed: get_fixed_state_data_from_db(table_name, fixed_state_size),
    input_fixed: get_fixed_input_data_from_db(table_name, fixed_input_size),
  }
  first_column_name_src = {
    state_fixed: "%begin{tabular}{@{}c@{}}%# of%%Monitored%%Ciphertexts%end{tabular}",
    input_fixed: "%begin{tabular}{@{}c@{}}%# of%%States%end{tabular}",
  }
  first_column_value_key_src = {
    state_fixed: :input_size,
    input_fixed: :state_size,
  }

  [:state_fixed, :input_fixed].each do |kind|
    data = data_src[kind]
    first_column_name = first_column_name_src[kind]
    first_column_value_key = first_column_value_key_src[kind]

    sio = StringIO.new
    ### Table header
    sio.puts <<"EOS"
%begin{tabular}{c|c||c|c|c||c|c}%toprule
%multirow{3}{*}{Algorithm} &
%multirow{3}{*}{#{first_column_name}} &
%multicolumn{4}{c|}{Runtime (s)} &
%multirow{3}{*}{%begin{tabular}[c]{@{}c@{}}Memoery%% Usage%% (GiB)%end{tabular}} %% %cline{3-6}
&
&
%multirow{2}{*}{%CMux{}} &
%multirow{2}{*}{%Bootstrapping{}} &
%multirow{2}{*}{%CircuitBootstrapping{}} &
%multirow{2}{*}{Total} & %%
&&&&&&%%
EOS
    ### Table body
    algorithm_keys.each_with_index do |algorithm_key, ki|
      algorithm = titles[ki]
      sio.puts "%midrule"
      sio.puts "%multirow{#{data[algorithm_key].size}}{*}{#{algorithm}}"
      data[algorithm_key].each_with_index do |f, index|
        first_column_value = case kind
          when :state_fixed
            "#{f[:input_size]}000"
          when :input_fixed
            "#{f[:state_size]}"
          end
        sio.puts [
          "",
          first_column_value,
          "#{format_float(f[:cmux_sum_mean])}",
          "#{format_float(f[:bs_sum_mean])}",
          "#{format_float(f[:cb_sum_mean])}",
          "#{format_float(f[:run_mean])}",
          "#{format_float(f[:mem_mean])}%%",
        ].join(" & ")
      end
    end
    ### Table footer
    sio.puts <<"EOS"
%bottomrule
%end{tabular}
EOS
    puts sio.string.gsub("%", "\\")
    puts
  end
end

def print_csv(table_name)
  fixed_state_size = 500
  fixed_input_size = 50000
  keys = ["reversed", "bbs-150"]
  data_src = {
    state_fixed: get_fixed_state_data_from_db(table_name, fixed_state_size),
    input_fixed: get_fixed_input_data_from_db(table_name, fixed_input_size),
  }
  size_key_src = {
    state_fixed: :input_size,
    input_fixed: :state_size,
  }
  output_filename_src = {
    state_fixed: "#{table_name}-fixed-state",
    input_fixed: "#{table_name}-fixed-input",
  }

  [:state_fixed, :input_fixed].each do |kind|
    data = data_src[kind]
    size_key = size_key_src[kind]
    output_filename = output_filename_src[kind]

    keys.each_with_index do |key, index|
      values = data[key].map do |f|
        [f[size_key], f[:run_mean], f[:run_stddev]]
      end
      CSV.open("#{output_filename}-#{key}.csv", "wb") do |csv|
        values.each do |row|
          csv << row
        end
      end
    end
  end
end

def print_gnuplot2(table_names)
  fixed_state_size = 500
  fixed_input_size = 50000
  term_tikz_size = "10,10"

  keys = ["reversed", "bbs-150"]
  titles = ["WS \\ReverseStream", "WS \\BlockStream", "Laptop \\ReverseStream", "Laptop \\BlockStream"]
  #keys = ["offline", "reversed", "bbs-150"]
  #titles = ["Offline", "ReverseStream", "BlockStream"]
  #titles = ["\\Cref{alg:offline}", "\\Cref{alg:reversed}", "\\Cref{alg:bbs}"]
  line_style = [1, 1, 2, 2]
  point_style = [1, 4, 1, 4]
  size_key_src = {
    state_fixed: :input_size,
    input_fixed: :state_size,
  }
  output_filename_src = {
    state_fixed: "#{table_names.join("-")}-fixed-state",
    input_fixed: "#{table_names.join("-")}-fixed-input",
  }
  xylabel_src = {
    state_fixed: ["\\# of Monitored Ciphertexts ($\\times 10^3$)", "time (sec)"],
    input_fixed: ["\\# of States (states)", "time (sec)"],
  }
  xyrange_src = {
    state_fixed: ["[5:56]", "[0:250]"],
    input_fixed: ["[0:510]", "[0:250]"],
  }

  [:state_fixed, :input_fixed].each do |kind|
    size_key = size_key_src[kind]
    output_filename = output_filename_src[kind]
    xlabel, ylabel = xylabel_src[kind]
    xrange, yrange = xyrange_src[kind]
    points = []

    table_names.each_with_index do |table_name, table_index|
      data = case kind
        when :state_fixed
          get_fixed_state_data_from_db(table_name, fixed_state_size)
        when :input_fixed
          get_fixed_input_data_from_db(table_name, fixed_input_size)
        end
      keys.each_with_index do |key, key_index|
        values = data[key].map do |f|
          [f[size_key], f[:run_mean], f[:run_stddev]]
        end
        index = table_index * keys.size + key_index
        points.push([
          *values.transpose,
          with: :linespoints,
          title: titles[index],
          lt: line_style[index],
          lw: 2,
          pt: point_style[index],
          ps: 1,
        ])
      end
    end

    Numo.gnuplot do
      case $export_type
      when :tex
        set :term, :lua, :tikz
        set :output, "#{output_filename}.tex"
        set :term, :tikz, :size, term_tikz_size
      when :pdf
        set :terminal, :pdf, :font, "Helvetica,20"
        set :output, "#{output_filename}.pdf"
      end
      set :monochrom
      set :xlabel, xlabel
      set :ylabel, ylabel
      set :xrange, xrange
      set :yrange, yrange
      plot *points
    end
  end
end

def print_gnuplot(table_name)
  fixed_state_size = 500
  fixed_input_size = 50000
  term_tikz_size = "6,3"

  keys = ["reversed", "bbs-150"]
  titles = ["\\ReverseStream", "\\BlockStream"]
  #keys = ["offline", "reversed", "bbs-150"]
  #titles = ["Offline", "ReverseStream", "BlockStream"]
  #titles = ["\\Cref{alg:offline}", "\\Cref{alg:reversed}", "\\Cref{alg:bbs}"]
  line_style = [1, 2, 3, 4]
  point_style = [1, 2, 4, 5]
  data_src = {
    state_fixed: get_fixed_state_data_from_db(table_name, fixed_state_size),
    input_fixed: get_fixed_input_data_from_db(table_name, fixed_input_size),
  }
  size_key_src = {
    state_fixed: :input_size,
    input_fixed: :state_size,
  }
  output_filename_src = {
    state_fixed: "#{table_name}-fixed-state",
    input_fixed: "#{table_name}-fixed-input",
  }
  xylabel_src = {
    state_fixed: ["\\# of Monitored Ciphertexts ($\\times 10^3$)", "time (sec)"],
    input_fixed: ["\\# of States (states)", "time (sec)"],
  }
  xyrange_src = {
    state_fixed: ["[5:56]", "[0:200]"],
    input_fixed: ["[0:510]", "[0:200]"],
  }

  [:state_fixed, :input_fixed].each do |kind|
    data = data_src[kind]
    size_key = size_key_src[kind]
    output_filename = output_filename_src[kind]
    xlabel, ylabel = xylabel_src[kind]
    xrange, yrange = xyrange_src[kind]

    points = []
    keys.each_with_index do |key, index|
      values = data[key].map do |f|
        [f[size_key], f[:run_mean], f[:run_stddev]]
      end
      #points.push([
      #  *values.transpose,
      #  with: :errorbars,
      #  notitle: true,
      #  lt: index,
      #  lw: 3,
      #])
      points.push([
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
        set :output, "#{output_filename}.tex"
        set :term, :tikz, :size, term_tikz_size, :font, ",8"
        set :ylabel, :offset, "-1, 0"
      when :pdf
        set :terminal, :pdf, :font, "Helvetica,20"
        set :output, "#{output_filename}.pdf"
      end
      set :monochrom
      set :xlabel, xlabel
      set :ylabel, ylabel
      set :xrange, xrange
      set :yrange, yrange
      #set :key, :spacing, 0.9
      plot *points
    end
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
when "plot2"
  print_usage_and_exit unless ARGV.size >= 3
  print_gnuplot2(ARGV[1..])
when "csv"
  print_usage_and_exit unless ARGV.size == 2
  print_csv(ARGV[1])
when "tabular"
  print_tabular(ARGV[1])
else
  print_usage_and_exit
end
