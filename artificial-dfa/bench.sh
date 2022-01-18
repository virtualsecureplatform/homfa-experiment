#!/usr/bin/bash -eu

BUILD_BIN=${BUILD_BIN:-"build/bin"}
BENCHMARK=$BUILD_BIN/benchmark
OUTDIR="log/$(date +'%Y%m%d%H%M%S')"
NUM_AP=1
OUT_FREQ=150
FLUT_QUEUE_SIZE=15
FLUT_MAX_SECOND_LUT_DEPTH=8
REVERSED_BOOTSTRAPPING_FREQ=30000
OFFLINE_BOOTSTRAPPING_FREQ=30000
RUN_ONLY_PLAIN=${RUN_ONLY_PLAIN:-"0"}

failwith(){
    echo -ne "\e[1;31m[ERROR]\e[0m "
    echo "$1"
    exit 1
}

run_homfa(){
    case "$1" in
        "offline" )
            { /usr/bin/time -v $BENCHMARK offline --spec $2 --in $3 --bootstrapping-freq $OFFLINE_BOOTSTRAPPING_FREQ --ap $NUM_AP  > "$OUTDIR/$4.log" ; } 2> "$OUTDIR/$4_mem.log"
            ;;
        "reversed" )
            { /usr/bin/time -v $BENCHMARK reversed  --spec $2 --in $3 --bootstrapping-freq $REVERSED_BOOTSTRAPPING_FREQ --out-freq $OUT_FREQ --ap $NUM_AP --spec-reversed > "$OUTDIR/$4.log" ; } 2> "$OUTDIR/$4_mem.log"
            ;;
        "bbs-150" )
            { /usr/bin/time -v $BENCHMARK bbs --spec $2 --in $3 --out-freq $OUT_FREQ --ap $NUM_AP --queue-size 150 > "$OUTDIR/$4.log" ; } 2> "$OUTDIR/$4_mem.log"
            ;;
        "plain" )
            { /usr/bin/time -v $BENCHMARK plain --spec $2 --in $3 --out-freq $OUT_FREQ --ap $NUM_AP > "$OUTDIR/$4.log" ; } 2> "$OUTDIR/$4_mem.log"
            ;;
        * )
            failwith "Invalid run $1"
            ;;
    esac
}

run_benchmark(){
    spec_filepath="spec/$2.spec"
    rev_spec_filepath="spec/$2-rev.spec"
    input_filepath="in/$3.in"
    log_file_prefix="$1_$2_$3"

    # Debug print
    echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] Running benchmark: $1 $2 $3 > $log_file_prefix"

    if [ $RUN_ONLY_PLAIN != "0" -a $1 != "plain" ]; then
        echo -e "\t=> RUN_ONLY_PLAIN flag is set, so skip."
        return
    fi

    case "$1" in
        "reversed" )
            run_homfa reversed $rev_spec_filepath $input_filepath $log_file_prefix
            ;;
        * )
            run_homfa $1 $spec_filepath $input_filepath $log_file_prefix
            ;;
    esac

    echo -e "\t=> done."
}

mkdir -p $OUTDIR

ruby gen_bench_automaton.rb 10   > spec/size-0010.spec
ruby gen_bench_automaton.rb 10   > spec/size-0010-rev.spec
ruby gen_bench_automaton.rb 50   > spec/size-0050.spec
ruby gen_bench_automaton.rb 50   > spec/size-0050-rev.spec
ruby gen_bench_automaton.rb 100  > spec/size-0100.spec
ruby gen_bench_automaton.rb 100  > spec/size-0100-rev.spec
ruby gen_bench_automaton.rb 200  > spec/size-0200.spec
ruby gen_bench_automaton.rb 200  > spec/size-0200-rev.spec
ruby gen_bench_automaton.rb 300  > spec/size-0300.spec
ruby gen_bench_automaton.rb 300  > spec/size-0300-rev.spec
ruby gen_bench_automaton.rb 400  > spec/size-0400.spec
ruby gen_bench_automaton.rb 400  > spec/size-0400-rev.spec
ruby gen_bench_automaton.rb 500  > spec/size-0500.spec
ruby gen_bench_automaton.rb 500  > spec/size-0500-rev.spec
#ruby gen_bench_automaton.rb 1000 > spec/size-1000.spec
#ruby gen_bench_automaton.rb 1000 > spec/size-1000-rev.spec
seq 10000 | while read line; do echo -n 1; done | ruby ../01tobin.rb 1 > in/size-10000bit.in
seq 20000 | while read line; do echo -n 1; done | ruby ../01tobin.rb 1 > in/size-20000bit.in
seq 30000 | while read line; do echo -n 1; done | ruby ../01tobin.rb 1 > in/size-30000bit.in
seq 40000 | while read line; do echo -n 1; done | ruby ../01tobin.rb 1 > in/size-40000bit.in
seq 50000 | while read line; do echo -n 1; done | ruby ../01tobin.rb 1 > in/size-50000bit.in

num_states=(0010 0050 0100 0200 0300 0400 0500)
num_inputs=(10000 20000 30000 40000 50000)

for num_state in "${num_states[@]}"; do
    for num_input in "${num_inputs[@]}"; do
        run_benchmark plain    "size-${num_state}" "size-${num_input}bit"
        run_benchmark offline  "size-${num_state}" "size-${num_input}bit"
        run_benchmark reversed "size-${num_state}" "size-${num_input}bit"
        run_benchmark bbs-150  "size-${num_state}" "size-${num_input}bit"
    done
done
