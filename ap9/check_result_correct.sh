#!/usr/bin/bash -eu

cd "$1"

if [ -f qtrlwe2_towards-001.spec_adult-001-night-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_towards-001.spec_adult-001-night-bg.in.log) \
        <(grep "result" qtrlwe2_towards-001.spec_adult-001-night-bg.in.log)
fi
if [ -f reversed_towards-001.spec_adult-001-night-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_towards-001.spec_adult-001-night-bg.in.log) \
        <(grep "result" reversed_towards-001-rev.spec_adult-001-night-bg.in.log)
fi
if [ -f qtrlwe2_towards-002.spec_adult-001-night-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_towards-002.spec_adult-001-night-bg.in.log) \
        <(grep "result" qtrlwe2_towards-002.spec_adult-001-night-bg.in.log)
fi
if [ -f reversed_towards-002.spec_adult-001-night-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_towards-002.spec_adult-001-night-bg.in.log) \
        <(grep "result" reversed_towards-002-rev.spec_adult-001-night-bg.in.log)
fi
if [ -f qtrlwe2_towards-004.spec_adult-001-night-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_towards-004.spec_adult-001-night-bg.in.log) \
        <(grep "result" qtrlwe2_towards-004.spec_adult-001-night-bg.in.log)
fi
if [ -f reversed_towards-004.spec_adult-001-night-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_towards-004.spec_adult-001-night-bg.in.log) \
        <(grep "result" reversed_towards-004-rev.spec_adult-001-night-bg.in.log)
fi
if [ -f qtrlwe2_damon-001.spec_adult-001-7days-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-001.spec_adult-001-7days-bg.in.log) \
        <(grep "result" qtrlwe2_damon-001.spec_adult-001-7days-bg.in.log)
fi
if [ -f reversed_damon-001-rev.spec_adult-001-7days-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-001.spec_adult-001-7days-bg.in.log) \
        <(grep "result" reversed_damon-001-rev.spec_adult-001-7days-bg.in.log)
fi
if [ -f qtrlwe2_damon-002.spec_adult-001-7days-dbg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-002.spec_adult-001-7days-dbg.in.log) \
        <(grep "result" qtrlwe2_damon-002.spec_adult-001-7days-dbg.in.log)
fi
if [ -f reversed_damon-002-rev.spec_adult-001-7days-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-002.spec_adult-001-7days-bg.in.log) \
        <(grep "result" reversed_damon-002-rev.spec_adult-001-7days-bg.in.log)
fi
if [ -f qtrlwe2_damon-004.spec_adult-001-7days-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-004.spec_adult-001-7days-bg.in.log) \
        <(grep "result" qtrlwe2_damon-004.spec_adult-001-7days-bg.in.log)
fi
if [ -f reversed_damon-004-rev.spec_adult-001-7days-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-004.spec_adult-001-7days-bg.in.log) \
        <(grep "result" reversed_damon-004-rev.spec_adult-001-7days-bg.in.log)
fi
if [ -f qtrlwe2_damon-005.spec_adult-001-7days-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-005.spec_adult-001-7days-bg.in.log) \
        <(grep "result" qtrlwe2_damon-005.spec_adult-001-7days-bg.in.log)
fi
if [ -f reversed_damon-005-rev.spec_adult-001-7days-bg.in.log ]; then
    echo -n "."
    diff \
        <(grep "result" plain_damon-005.spec_adult-001-7days-bg.in.log) \
        <(grep "result" reversed_damon-005-rev.spec_adult-001-7days-bg.in.log)
fi
