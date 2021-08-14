#!/usr/bin/bash -xeu

BUILD_BIN=${BUILD_BIN:-"build/bin"}
BENCHMARK=$BUILD_BIN/benchmark

# cat <(seq 1 9999 | while read i; do echo -n "11111"; done) <(echo -n "11011") | ruby ../01tobin.rb 5 > 10000_5ap.in

failwith(){
    echo -ne "\e[1;31m[ERROR]\e[0m "
    echo "$1"
    exit 1
}

run_benchmark(){
    case "$1" in
        "offline" )
	    $BENCHMARK offline --spec $2 --in $3 --bootstrapping-freq 30000 --ap 5  > $1_$2_$3.log
            ;;
        "reversed" )
            $BENCHMARK reversed --spec $2 --in $3 --bootstrapping-freq 30000 --out-freq 15 --ap 5  > $1_$2_$3.log
            ;;
        "qtrlwe2" )
	    $BENCHMARK qtrlwe2 --spec $2 --in $3 --bootstrapping-freq 1 --out-freq 15 --ap 5 --queue-size 15 --max-second-lut-depth 8 > $1_$2_$3.log
            ;;
        "plain" )
	    $BENCHMARK plain --spec $2 --in $3 --out-freq 15 --ap 5 > $1_$2_$3.log
            ;;
        * )
            failwith "Invalid run $1"
            ;;
    esac
}

run_benchmark plain X8_5ap.spec 10000_5ap.in
run_benchmark offline X8_5ap.spec 10000_5ap.in
run_benchmark qtrlwe2 X8_5ap.spec 10000_5ap.in
run_benchmark reversed X8_5ap.spec 10000_5ap.in

run_benchmark plain X9_5ap.spec 10000_5ap.in
run_benchmark offline X9_5ap.spec 10000_5ap.in
run_benchmark qtrlwe2 X9_5ap.spec 10000_5ap.in
run_benchmark reversed X9_5ap.spec 10000_5ap.in

run_benchmark plain X10_5ap.spec 10000_5ap.in
run_benchmark offline X10_5ap.spec 10000_5ap.in
run_benchmark qtrlwe2 X10_5ap.spec 10000_5ap.in
run_benchmark reversed X10_5ap.spec 10000_5ap.in
