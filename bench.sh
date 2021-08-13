#!/usr/bin/bash -eux

BUILD_BIN=${BUILD_BIN:-"build/bin"}
BENCHMARK=$BUILD_BIN/benchmark

$BENCHMARK offline --spec damon-001.spec --in adult-001-bg.in --bootstrapping-freq 30000 --ap 5  > offline-damon-001.log
$BENCHMARK offline --spec damon-002.spec --in adult-001-dbg.in --bootstrapping-freq 30000 --ap 5 > offline-damon-002.log
$BENCHMARK offline --spec damon-004.spec --in adult-001-bg.in --bootstrapping-freq 30000 --ap 5  > offline-damon-004.log
$BENCHMARK offline --spec damon-005.spec --in adult-001-bg.in --bootstrapping-freq 30000 --ap 5  > offline-damon-005.log
$BENCHMARK reversed --spec damon-001.spec --in adult-001-bg.in --bootstrapping-freq 30000 --out-freq 15 --ap 5  > reversed-damon-001.log
$BENCHMARK reversed --spec damon-002.spec --in adult-001-dbg.in --bootstrapping-freq 30000 --out-freq 15 --ap 5 > reversed-damon-002.log
$BENCHMARK reversed --spec damon-004.spec --in adult-001-bg.in --bootstrapping-freq 30000 --out-freq 15 --ap 5 > reversed-damon-004.log
$BENCHMARK reversed --spec damon-005.spec --in adult-001-bg.in --bootstrapping-freq 30000 --out-freq 15 --ap 5 > reversed-damon-005.log
$BENCHMARK qtrlwe2 --spec damon-001.spec --in adult-001-bg.in --bootstrapping-freq 1 --out-freq 15 --ap 5 --queue-size 15 --max_second_lut_depth 8 > qtrlwe2-damon-001.log
$BENCHMARK qtrlwe2 --spec damon-002.spec --in adult-001-dbg.in --bootstrapping-freq 1 --out-freq 15 --ap 5 --queue-size 15 --max_second_lut_depth 8 > qtrlwe2-damon-002.log
$BENCHMARK qtrlwe2 --spec damon-004.spec --in adult-001-bg.in --bootstrapping-freq 1 --out-freq 15 --ap 5 --queue-size 15 --max_second_lut_depth 8 > qtrlwe2-damon-004.log
$BENCHMARK qtrlwe2 --spec damon-005.spec --in adult-001-bg.in --bootstrapping-freq 1 --out-freq 15 --ap 5 --queue-size 15 --max_second_lut_depth 8 > qtrlwe2-damon-005.log
