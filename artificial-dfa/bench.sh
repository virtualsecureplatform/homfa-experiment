#!/usr/bin/bash -eu

BUILD_BIN=${BUILD_BIN:-"build/bin"}
BENCHMARK=$BUILD_BIN/benchmark
OUTDIR="log/$(date +'%Y%m%d%H%M%S')"
NUM_AP=1
OUT_FREQ=${OUT_FREQ:-"30"}
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
        "qtrlwe2" | "flut" )
            { /usr/bin/time -v $BENCHMARK qtrlwe2 --spec $2 --in $3 --bootstrapping-freq 1 --out-freq $OUT_FREQ --ap $NUM_AP --queue-size $FLUT_QUEUE_SIZE --max-second-lut-depth $FLUT_MAX_SECOND_LUT_DEPTH > "$OUTDIR/$4.log" ; } 2> "$OUTDIR/$4_mem.log"
            ;;
        "bbs" )
            { /usr/bin/time -v $BENCHMARK bbs --spec $2 --in $3 --out-freq $OUT_FREQ --ap $NUM_AP --queue-size $OUT_FREQ > "$OUTDIR/$4.log" ; } 2> "$OUTDIR/$4_mem.log"
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

mkdir $OUTDIR

run_benchmark plain    size-0010 size-10000bit
run_benchmark offline  size-0010 size-10000bit
run_benchmark reversed size-0010 size-10000bit
run_benchmark bbs      size-0010 size-10000bit
run_benchmark qtrlwe2  size-0010 size-10000bit

run_benchmark plain    size-0010 size-100000bit
run_benchmark offline  size-0010 size-100000bit
run_benchmark reversed size-0010 size-100000bit
run_benchmark bbs      size-0010 size-100000bit
run_benchmark qtrlwe2  size-0010 size-100000bit

run_benchmark plain    size-0100 size-10000bit
run_benchmark offline  size-0100 size-10000bit
run_benchmark reversed size-0100 size-10000bit
run_benchmark bbs      size-0100 size-10000bit
run_benchmark qtrlwe2  size-0100 size-10000bit

run_benchmark plain    size-0100 size-100000bit
run_benchmark offline  size-0100 size-100000bit
run_benchmark reversed size-0100 size-100000bit
run_benchmark bbs      size-0100 size-100000bit
run_benchmark qtrlwe2  size-0100 size-100000bit

run_benchmark plain    size-0500 size-10000bit
run_benchmark offline  size-0500 size-10000bit
run_benchmark reversed size-0500 size-10000bit
run_benchmark bbs      size-0500 size-10000bit
run_benchmark qtrlwe2  size-0500 size-10000bit

run_benchmark plain    size-0500 size-100000bit
run_benchmark offline  size-0500 size-100000bit
run_benchmark reversed size-0500 size-100000bit
run_benchmark bbs      size-0500 size-100000bit
run_benchmark qtrlwe2  size-0500 size-100000bit

run_benchmark plain    size-1000 size-10000bit
run_benchmark offline  size-1000 size-10000bit
run_benchmark reversed size-1000 size-10000bit
run_benchmark bbs      size-1000 size-10000bit
run_benchmark qtrlwe2  size-1000 size-10000bit

run_benchmark plain    size-1000 size-100000bit
run_benchmark offline  size-1000 size-100000bit
run_benchmark reversed size-1000 size-100000bit
run_benchmark bbs      size-1000 size-100000bit
run_benchmark qtrlwe2  size-1000 size-100000bit
