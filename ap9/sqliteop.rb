#!/usr/bin/ruby

require "sqlite3"
require "byebug"
require "ostruct"

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
  SQLite3::Database.new "ap9.sqlite3"
end

def import_result(table_name, result_dir)
  logfile_names = [
    "bbs_damon-001.spec_adult-001-7days-bg.in_45.log",
    "bbs_damon-004.spec_adult-001-7days-bg.in_45.log",
    "bbs_damon-005.spec_adult-001-7days-bg.in_45.log",
    "bbs_towards-001.spec_adult-001-night-bg.in_45.log",
    "bbs_towards-002.spec_adult-001-night-bg.in_45.log",
    "bbs_towards-004.spec_adult-001-night-bg.in_45.log",
    "offline_damon-001.spec_adult-001-7days-bg.in_0.log",
    "offline_damon-004.spec_adult-001-7days-bg.in_0.log",
    "offline_damon-005.spec_adult-001-7days-bg.in_0.log",
    "offline_towards-001.spec_adult-001-night-bg.in_0.log",
    "offline_towards-002.spec_adult-001-night-bg.in_0.log",
    "offline_towards-004.spec_adult-001-night-bg.in_0.log",
    "plain_damon-001.spec_adult-001-7days-bg.in_45.log",
    "plain_damon-004.spec_adult-001-7days-bg.in_45.log",
    "plain_damon-005.spec_adult-001-7days-bg.in_45.log",
    "plain_towards-001.spec_adult-001-night-bg.in_45.log",
    "plain_towards-002.spec_adult-001-night-bg.in_45.log",
    "plain_towards-004.spec_adult-001-night-bg.in_45.log",
    "reversed_damon-001-rev.spec_adult-001-7days-bg.in_45.log",
    "reversed_damon-004-rev.spec_adult-001-7days-bg.in_45.log",
    "reversed_damon-005-rev.spec_adult-001-7days-bg.in_45.log",
  ]

  data2 = logfile_names.map { |filename|
    [filename, {
      enc_sum: [],
      run_sum: [],
      dec_sum: [],

      init: nil,
      cb_sum: nil,
      cb_num: nil,
      cmux_sum: nil,
      cmux_num: nil,
      bs_sum: nil,
      bs_num: nil,
    }]
  }.to_h

  logfile_names.each do |logfile_name|
    Dir.glob(File.join(result_dir, "**", logfile_name)).each do |filename|
      data = {
        enc: [],
        run: [],
        dec: [],
      }
      entry2 = data2[logfile_name]
      File.open(filename).each do |line|
        fields = line.split(",")
        kind_sym = fields[0].to_sym
        case kind_sym
        when :enc, :run, :dec
          data[kind_sym].push fields[1].to_i
        when :init
          raise "Duplicate entry: #{logfile_name} init" unless entry2[:init].nil?
          entry2[:init] = fields[1].to_i
        when :"time_recorder-circuit_bootstrapping"
          raise "Duplicate entry: #{logfile_name} cb" unless entry2[:cb_sum].nil?
          entry2[:cb_sum] = fields[2].to_i
          entry2[:cb_num] = fields[1].to_i
        when :"time_recorder-cmux"
          raise "Duplicate entry: #{logfile_name} cmux" unless entry2[:cmux_sum].nil?
          entry2[:cmux_sum] = fields[2].to_i
          entry2[:cmux_num] = fields[1].to_i
        when :"time_recorder-bootstrapping"
          raise "Duplicate entry: #{logfile_name} bs" unless entry2[:bs_sum].nil?
          entry2[:bs_sum] = fields[2].to_i
          entry2[:bs_num] = fields[1].to_i
        end
      end
      entry2[:enc_sum].push data[:enc].sum
      entry2[:run_sum].push data[:run].sum
      entry2[:dec_sum].push data[:dec].sum
    end
  end

  # dump
  db = open_db
  db.execute <<-SQL
    CREATE TABLE #{table_name} (
      algorithm TEXT,
      spec STRING,
      input STRING,
      output_intv INTEGER,

      init INTEGER,

      enc_size INTEGER,
      enc_mean INTEGER,
      enc_stddev REAL,

      run_size INTEGER,
      run_mean INTEGER,
      run_stddev REAL,

      dec_size INTEGER,
      dec_mean INTEGER,
      dec_stddev REAL,

      cb_sum INTEGER,
      cb_num INTEGER,

      cmux_sum INTEGER,
      cmux_num INTEGER,

      bs_sum INTEGER,
      bs_num INTEGER,

      PRIMARY KEY (algorithm, spec, input)
    );
  SQL

  re = /^(?<algorithm>[^_]+)_(?<spec>[^_]+)_(?<input>[^_]+)_(?<output_intv>[0-9]+)\.log/
  data2.each do |filename, data|
    m = re.match(filename)
    if m.nil?
      $stderr.puts "Regex not match: #{filename}"
      next
    end
    db.execute "INSERT INTO #{table_name} VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
               m[:algorithm],
               m[:spec],
               m[:input],
               m[:output_intv],
               data[:init],
               data[:enc_sum].size,
               data[:enc_sum].mean,
               data[:enc_sum].stddev,
               data[:run_sum].size,
               data[:run_sum].mean,
               data[:run_sum].stddev,
               data[:dec_sum].size,
               data[:dec_sum].mean,
               data[:dec_sum].stddev,
               data[:cb_sum],
               (data[:cb_num] || [0])[0],
               data[:cmux_sum],
               (data[:cmux_num] || [0])[0],
               data[:bs_sum],
               (data[:bs_num] || [0])[0]
  end
end

def export_latex_tabular(table_name)
  data = {}
  db = open_db
  db.execute("SELECT algorithm,spec,input,run_mean,run_stddev FROM #{table_name}").each do |fields|
    algorithm, spec, input, run_mean, run_stddev = fields
    run_mean_s = run_mean.to_f / 1000000
    run_mean_ms = run_mean.to_f / 1000
    run_stddev_s = run_stddev.to_f / 1000000
    run_stddev_ms = run_stddev.to_f / 1000

    alg = algorithm[0..2]
    fml = case spec
      when /^towards-00([124])(-rev)?\.spec$/
        "psi#{$1}"
      when /^damon-00([145])(-rev)?\.spec$/
        "phi#{$1}"
      else
        raise "Unknown spec"
      end
    run_key = "#{alg}_#{fml}_r"
    run_per_input_key = "#{alg}_#{fml}_rpi"

    input_size = case input
      when "adult-001-7days-bg.in"
        10081
      when "adult-001-night-bg.in"
        721
      end
    data[run_key] = sprintf("%.2f\\pm%.2f", run_mean_s, run_stddev_s)
    data[run_per_input_key] = sprintf("%.2f\\pm%.2f", run_mean_ms / input_size, run_stddev_ms / input_size)
  end
  data["rev_psi1_r"] = data["rev_psi1_rpi"] = "\\text{---}"
  data["rev_psi2_r"] = data["rev_psi2_rpi"] = "\\text{---}"
  data["rev_psi4_r"] = data["rev_psi4_rpi"] = "\\text{---}"

  d = OpenStruct.new(data)
  puts <<"EOS".gsub("%", "\\")
%begin{tabular}{ccccc|c|c}%toprule
formula                   & %#states              & %#rev states             & %#inputs               & algorithm          & time (s)        & time (ms/input)   %%%midrule

%multirow{3}{*}{$%psi_1$} & %multirow{3}{*}{10524} & %multirow{3}{*}{---}    & %multirow{9}{*}{721}   & %ref{alg:offline}  & $#{d.off_psi1_r}$ & $#{d.off_psi1_rpi}$ %%
                          &                       &                          &                        & %ref{alg:reversed} & $#{d.rev_psi1_r}$ & $#{d.rev_psi1_rpi}$ %%
                          &                       &                          &                        & %ref{alg:bbs}      & $#{d.bbs_psi1_r}$ & $#{d.bbs_psi1_rpi}$ %%%hline
%multirow{3}{*}{$%psi_2$} & %multirow{3}{*}{11126} & %multirow{3}{*}{---}    &                        & %ref{alg:offline}  & $#{d.off_psi2_r}$ & $#{d.off_psi2_rpi}$ %%
                          &                       &                          &                        & %ref{alg:reversed} & $#{d.rev_psi2_r}$ & $#{d.rev_psi2_rpi}$ %%
                          &                       &                          &                        & %ref{alg:bbs}      & $#{d.bbs_psi2_r}$ & $#{d.bbs_psi2_rpi}$ %%%hline
%multirow{3}{*}{$%psi_4$} & %multirow{3}{*}{7026} & %multirow{3}{*}{---}     &                        & %ref{alg:offline}  & $#{d.off_psi4_r}$ & $#{d.off_psi4_rpi}$ %%
                          &                       &                          &                        & %ref{alg:reversed} & $#{d.rev_psi4_r}$ & $#{d.rev_psi4_rpi}$ %%
                          &                       &                          &                        & %ref{alg:bbs}      & $#{d.bbs_psi4_r}$ & $#{d.bbs_psi4_rpi}$ %%%midrule%midrule

%multirow{3}{*}{$%phi_1$} & %multirow{3}{*}{21}   & %multirow{3}{*}{20}      & %multirow{9}{*}{10081} & %ref{alg:offline}  & $#{d.off_phi1_r}$ & $#{d.off_phi1_rpi}$ %%
                          &                       &                          &                        & %ref{alg:reversed} & $#{d.rev_phi1_r}$ & $#{d.rev_phi1_rpi}$ %%
                          &                       &                          &                        & %ref{alg:bbs}      & $#{d.bbs_phi1_r}$ & $#{d.bbs_phi1_rpi}$ %%%hline
%multirow{3}{*}{$%phi_4$} & %multirow{3}{*}{237}  & %multirow{3}{*}{237}     &                        & %ref{alg:offline}  & $#{d.off_phi4_r}$ & $#{d.off_phi4_rpi}$ %%
                          &                       &                          &                        & %ref{alg:reversed} & $#{d.rev_phi4_r}$ & $#{d.rev_phi4_rpi}$ %%
                          &                       &                          &                        & %ref{alg:bbs}      & $#{d.bbs_phi4_r}$ & $#{d.bbs_phi4_rpi}$ %%%hline
%multirow{3}{*}{$%phi_5$} & %multirow{3}{*}{390}  & %multirow{3}{*}{390}     &                        & %ref{alg:offline}  & $#{d.off_phi5_r}$ & $#{d.off_phi5_rpi}$ %%
                          &                       &                          &                        & %ref{alg:reversed} & $#{d.rev_phi5_r}$ & $#{d.rev_phi5_rpi}$ %%
                          &                       &                          &                        & %ref{alg:bbs}      & $#{d.bbs_phi5_r}$ & $#{d.bbs_phi5_rpi}$ %%%bottomrule
%end{tabular}
EOS
end

def print_usage_and_exit
  $stderr.puts "Usage: #{$0} import  TABLE-NAME RESULT-DIR"
  $stderr.puts "Usage: #{$0} tabular TABLE-NAME"
  exit 1
end

print_usage_and_exit unless ARGV.size >= 1

case ARGV[0]
when "import"
  print_usage_and_exit unless ARGV.size == 3
  import_result ARGV[1], ARGV[2]
when "tabular"
  print_usage_and_exit unless ARGV.size == 2
  export_latex_tabular ARGV[1]
else
  print_usage_and_exit
end
