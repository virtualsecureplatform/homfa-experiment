#!/usr/bin/ruby

=begin
\begin{table}[]
	\begin{tabular}{lllllll}
		$\psi_1$ & 7215 & 1856014 & 4326  & offline  & $0.87\pm{}0.02$    & $0.20\pm{}0.00$  \\
		         &      &         &       & reversed & $335.39\pm{}13.15$ & $77.53\pm{}3.04$ \\
		         &      &         &       & qtrlwe2  & $16.11\pm{}0.09$   & $3.73\pm{}0.02$  \\
		$\psi_2$ & 6015 & 1531414 & 4326  & offline  & $0.78\pm{}0.09$    & $0.18\pm{}0.02$  \\
		         &      &         &       & reversed & $270.93\pm{}1.42$  & $62.63\pm{}0.33$ \\
		         &      &         &       & qtrlwe2  & $16.06\pm{}0.18$   & $3.71\pm{}0.04$  \\
		$\psi_4$ & 4617 & ---     & 4326  & offline  & $0.39\pm{}0.02$    & $0.09\pm{}0.00$  \\
		         &      &         &       & reversed & ---                & ---              \\
		         &      &         &       & qtrlwe2  & $12.96\pm{}0.30$   & $3.00\pm{}0.07$  \\
		$\phi_1$ & 13   & 13      & 60486 & offline  & $6.47\pm{}0.05$    & $0.11\pm{}0.00$  \\
		         &      &         &       & reversed & $48.92\pm{}1.15$   & $0.81\pm{}0.02$  \\
		         &      &         &       & qtrlwe2  & $211.98\pm{}1.39$  & $3.50\pm{}0.02$  \\
		$\phi_2$ & 13   & 13      & 60480 & offline  & $5.77\pm{}0.04$    & $0.10\pm{}0.00$  \\
		         &      &         &       & reversed & $48.97\pm{}0.74$   & $0.81\pm{}0.01$  \\
		         &      &         &       & qtrlwe2  & $211.57\pm{}2.46$  & $3.50\pm{}0.04$  \\
		$\phi_4$ & 186  & 186     & 60486 & offline  & $16.46\pm{}0.15$   & $0.27\pm{}0.00$  \\
		         &      &         &       & reversed & $58.48\pm{}1.34$   & $0.97\pm{}0.02$  \\
		         &      &         &       & qtrlwe2  & $396.13\pm{}9.67$  & $6.55\pm{}0.16$  \\
		$\phi_5$ & 234  & 234     & 60486 & offline  & $17.38\pm{}0.12$   & $0.29\pm{}0.00$  \\
		         &      &         &       & reversed & $59.24\pm{}0.69$   & $0.98\pm{}0.01$  \\
		         &      &         &       & qtrlwe2  & $479.56\pm{}5.98$  & $7.93\pm{}0.10$
	\end{tabular}
\end{table}


=end

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
  "offline_damon-001.spec_adult-001-7days-bg.in.log",
  "offline_damon-002.spec_adult-001-7days-dbg.in.log",
  "offline_damon-004.spec_adult-001-7days-bg.in.log",
  "offline_damon-005.spec_adult-001-7days-bg.in.log",
  "offline_towards-001.spec_adult-001-night-bg.in.log",
  "offline_towards-002.spec_adult-001-night-bg.in.log",
  "offline_towards-004.spec_adult-001-night-bg.in.log",
  "reversed_damon-001-rev.spec_adult-001-7days-bg.in.log",
  "reversed_damon-002-rev.spec_adult-001-7days-dbg.in.log",
  "reversed_damon-004-rev.spec_adult-001-7days-bg.in.log",
  "reversed_damon-005-rev.spec_adult-001-7days-bg.in.log",
  "reversed_towards-001-rev.spec_adult-001-night-bg.in.log",
  "reversed_towards-002-rev.spec_adult-001-night-bg.in.log",
  "qtrlwe2_damon-001.spec_adult-001-7days-bg.in.log",
  "qtrlwe2_damon-002.spec_adult-001-7days-dbg.in.log",
  "qtrlwe2_damon-004.spec_adult-001-7days-bg.in.log",
  "qtrlwe2_damon-005.spec_adult-001-7days-bg.in.log",
  "qtrlwe2_towards-001.spec_adult-001-night-bg.in.log",
  "qtrlwe2_towards-002.spec_adult-001-night-bg.in.log",
  "qtrlwe2_towards-004.spec_adult-001-night-bg.in.log",
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
  csv << ["logfile_name", "enc_size", "enc_mean", "enc_stddev", "run_size", "run_mean", "run_stddev", "dec_size", "dec_mean", "dec_stddev"]
  data2.each do |filename, data|
    csv << [filename,
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

def tos(mean, stddev)
  "$#{sprintf("%.2f", mean)}\\pm{}#{sprintf("%.2f", stddev)}$"
end

def print(sio, data2, spec_filename, log_file, id, states, states_rev, in_size)
  offline_filename = "offline_#{spec_filename}.spec_#{log_file}"
  reversed_filename = "reversed_#{spec_filename}-rev.spec_#{log_file}"
  qtrlwe2_filename = "qtrlwe2_#{spec_filename}.spec_#{log_file}"

  run_mean = data2[offline_filename][:run_sum].mean
  run_stddev = data2[offline_filename][:run_sum].stddev
  sio <<
    "\\multirow{3}{*}{$\\#{id}$}&" <<
    "\\multirow{3}{*}{#{states}}&" <<
    "\\multirow{3}{*}{#{states_rev}}&" <<
    "\\multirow{3}{*}{#{in_size}}& offline &" <<
    tos(run_mean / 10 ** 6, run_stddev / 10 ** 6) << "&" <<
    tos(run_mean / in_size / 10 ** 3, run_stddev / in_size / 10 ** 3) <<
    "\\\\\n"

  if data2.key? reversed_filename
    run_mean = data2[reversed_filename][:run_sum].mean
    run_stddev = data2[reversed_filename][:run_sum].stddev
    sio << "&&&&reversed&" <<
      tos(run_mean / 10 ** 6, run_stddev / 10 ** 6) << "&" <<
      tos(run_mean / in_size / 10 ** 3, run_stddev / in_size / 10 ** 3) <<
      "\\\\\n"
  else
    sio << "&&&&reversed&---&---\\\\\n"
  end

  run_mean = data2[qtrlwe2_filename][:run_sum].mean
  run_stddev = data2[qtrlwe2_filename][:run_sum].stddev
  sio << "&&&&qtrlwe2&" <<
    tos(run_mean / 10 ** 6, run_stddev / 10 ** 6) << "&" <<
    tos(run_mean / in_size / 10 ** 3, run_stddev / in_size / 10 ** 3) <<
    "\\\\\n"
end

sio3 = StringIO.new
print sio3, data2, "towards-001", "adult-001-night-bg.in.log", "psi_1", 7215, 1856014, 4326
print sio3, data2, "towards-002", "adult-001-night-bg.in.log", "psi_2", 6015, 1531414, 4326
print sio3, data2, "towards-004", "adult-001-night-bg.in.log", "psi_4", 4617, "---", 4326
print sio3, data2, "damon-001", "adult-001-7days-bg.in.log", "phi_1", 13, 13, 60486
print sio3, data2, "damon-002", "adult-001-7days-dbg.in.log", "phi_2", 13, 13, 60480
print sio3, data2, "damon-004", "adult-001-7days-bg.in.log", "phi_4", 186, 186, 60486
print sio3, data2, "damon-005", "adult-001-7days-bg.in.log", "phi_5", 234, 234, 60486
puts sio3.string

#puts sio3.string
#puts
#puts sio2.string
#puts sio1.string
