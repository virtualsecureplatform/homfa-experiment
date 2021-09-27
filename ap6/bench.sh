#!/usr/bin/bash -eux

BUILD_BIN=${BUILD_BIN:-"build/bin"}
BENCHMARK=$BUILD_BIN/benchmark
OUTDIR=$(date +'log-%Y%m%d%H%M%S')

failwith(){
    echo -ne "\e[1;31m[ERROR]\e[0m "
    echo "$1"
    exit 1
}

run_benchmark(){
    case "$1" in
        "offline" )
            { /usr/bin/time -v $BENCHMARK offline --spec $2 --in $3 --bootstrapping-freq 30000 --ap 6  > "$OUTDIR/$1_$2_$3.log" ; } 2> "$OUTDIR/$1_$2_$3_mem.log"
            ;;
        "reversed" )
            { /usr/bin/time -v $BENCHMARK reversed  --spec $2 --in $3 --bootstrapping-freq 30000 --out-freq 30 --ap 6 --spec-reversed > "$OUTDIR/$1_$2_$3.log" ; } 2> "$OUTDIR/$1_$2_$3_mem.log"
            ;;
        "qtrlwe2" )
            { /usr/bin/time -v $BENCHMARK qtrlwe2 --spec $2 --in $3 --bootstrapping-freq 1 --out-freq 30 --ap 6 --queue-size 15 --max-second-lut-depth 8 > "$OUTDIR/$1_$2_$3.log" ; } 2> "$OUTDIR/$1_$2_$3_mem.log"
            ;;
        "bbs" )
            { /usr/bin/time -v $BENCHMARK bbs --spec $2 --in $3 --out-freq 30 --ap 6 --queue-size 30 > "$OUTDIR/$1_$2_$3.log" ; } 2> "$OUTDIR/$1_$2_$3_mem.log"
            ;;
        "plain" )
            { /usr/bin/time -v $BENCHMARK plain --spec $2 --in $3 --out-freq 30 --ap 6 > "$OUTDIR/$1_$2_$3.log" ; } 2> "$OUTDIR/$1_$2_$3_mem.log"
            ;;
        * )
            failwith "Invalid run $1"
            ;;
    esac
}

mkdir $OUTDIR

run_benchmark plain    damon-001.spec adult-001-7days-bg.in
run_benchmark offline  damon-001.spec adult-001-7days-bg.in
run_benchmark reversed damon-001-rev.spec adult-001-7days-bg.in
run_benchmark qtrlwe2  damon-001.spec adult-001-7days-bg.in
run_benchmark bbs      damon-001.spec adult-001-7days-bg.in

run_benchmark plain    damon-002.spec adult-001-7days-dbg.in
run_benchmark offline  damon-002.spec adult-001-7days-dbg.in
run_benchmark reversed damon-002-rev.spec adult-001-7days-dbg.in
run_benchmark qtrlwe2  damon-002.spec adult-001-7days-dbg.in
run_benchmark bbs      damon-002.spec adult-001-7days-dbg.in

run_benchmark plain    damon-004.spec adult-001-7days-bg.in
run_benchmark offline  damon-004.spec adult-001-7days-bg.in
run_benchmark reversed damon-004-rev.spec adult-001-7days-bg.in
run_benchmark qtrlwe2  damon-004.spec adult-001-7days-bg.in
run_benchmark bbs      damon-004.spec adult-001-7days-bg.in

run_benchmark plain    damon-005.spec adult-001-7days-bg.in
run_benchmark offline  damon-005.spec adult-001-7days-bg.in
run_benchmark reversed damon-005-rev.spec adult-001-7days-bg.in
run_benchmark qtrlwe2  damon-005.spec adult-001-7days-bg.in
run_benchmark bbs      damon-005.spec adult-001-7days-bg.in

run_benchmark plain    towards-001.spec adult-001-night-bg.in
run_benchmark offline  towards-001.spec adult-001-night-bg.in
run_benchmark reversed towards-001-rev.spec adult-001-night-bg.in
run_benchmark qtrlwe2  towards-001.spec adult-001-night-bg.in
run_benchmark bbs      towards-001.spec adult-001-night-bg.in

run_benchmark plain    towards-002.spec adult-001-night-bg.in
run_benchmark offline  towards-002.spec adult-001-night-bg.in
run_benchmark reversed towards-002-rev.spec adult-001-night-bg.in
run_benchmark qtrlwe2  towards-002.spec adult-001-night-bg.in
run_benchmark bbs      towards-002.spec adult-001-night-bg.in

run_benchmark plain    towards-004.spec adult-001-night-bg.in
run_benchmark offline  towards-004.spec adult-001-night-bg.in
#run_benchmark reversed towards-004-rev.spec adult-001-night-bg.in
run_benchmark qtrlwe2  towards-004.spec adult-001-night-bg.in
run_benchmark bbs      towards-004.spec adult-001-night-bg.in

