#!/usr/bin/bash -eu

failwith(){
    echo -ne "\e[1;31m[ERROR]\e[0m "
    echo "$1"
    exit 1
}

[ $# -eq 1 ] || failwith "Specify output directory"
OUTDIR=$1

BUILD_BIN=${BUILD_BIN:-"../../homfa/bin"}
BENCHMARK=$BUILD_BIN/benchmark
BOOTSTRAPPING_FREQ=30000

run_benchmark(){
    # Debug print
    echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] Running benchmark: $@"

    local mode=$1
    local ap_size=$2
    local spec_filepath=$3
    local input_filepath=$4
    local output_freq=$5
    local logfile="$OUTDIR/${mode}_${spec_filepath}_${input_filepath}_${output_freq}.log"
    local logfile_mem="$OUTDIR/${mode}_${spec_filepath}_${input_filepath}_${output_freq}_mem.log"

    case $mode in
        "offline" )
            { /usr/bin/time -v \
                $BENCHMARK offline \
                    --spec $spec_filepath \
                    --in $input_filepath \
                    --bootstrapping-freq $BOOTSTRAPPING_FREQ \
                    --ap $ap_size \
                    > $logfile ; } 2> $logfile_mem
            ;;

        "reversed" )
            { /usr/bin/time -v \
                $BENCHMARK reversed \
                    --spec $spec_filepath \
                    --in $input_filepath \
                    --bootstrapping-freq $BOOTSTRAPPING_FREQ \
                    --out-freq $output_freq \
                    --ap $ap_size \
                    --spec-reversed \
                    > $logfile ; } 2> $logfile_mem
            ;;

        "bbs" )
            { /usr/bin/time -v \
                $BENCHMARK bbs \
                    --spec $spec_filepath \
                    --in $input_filepath \
                    --out-freq $output_freq \
                    --ap $ap_size \
                    --queue-size $output_freq \
                    > $logfile ; } 2> $logfile_mem
            ;;

        "plain" )
            { /usr/bin/time -v \
                $BENCHMARK plain \
                    --spec $spec_filepath \
                    --in $input_filepath \
                    --out-freq $output_freq \
                    --ap $ap_size \
                    > $logfile ; } 2> $logfile_mem
            ;;

        * )
            failwith "Invalid run $1"
            ;;
    esac

    echo -e "\t=> done."
}

run_test(){
    local ap_size=$1
    local spec_filepath=$2
    local spec_rev_filepath=$3
    local input_filepath=$4
    local output_freq=$5
    local reversed_enabled=$6

    run_benchmark plain $ap_size $spec_filepath $input_filepath $output_freq
    # run_benchmark offline $ap_size $spec_filepath $input_filepath 0
    if [ $reversed_enabled -eq 1 ]; then
        run_benchmark reversed $ap_size $spec_rev_filepath $input_filepath $output_freq
    fi
    run_benchmark bbs $ap_size $spec_filepath $input_filepath $output_freq
}

mkdir -p $OUTDIR

if [ ! -f $BENCHMARK ]; then
    failwith "File benchmark not found in $BENCHMARK"
fi

run_test 9 damon-001.spec   damon-001-rev.spec   adult-001-7days-bg.in 9 1
run_test 9 damon-004.spec   damon-004-rev.spec   adult-001-7days-bg.in 9 1
run_test 9 damon-005.spec   damon-005-rev.spec   adult-001-7days-bg.in 9 1
#run_test 9 towards-001.spec towards-001-rev.spec adult-001-night-bg.in 9 1
#run_test 9 towards-002.spec towards-002-rev.spec adult-001-night-bg.in 9 1
run_test 9 towards-004.spec towards-004-rev.spec adult-001-night-bg.in 9 0
