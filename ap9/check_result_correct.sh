#!/usr/bin/bash -eu

#bbs_damon-001.spec_adult-001-7days-bg.in_45.log
#bbs_damon-004.spec_adult-001-7days-bg.in_45.log
#bbs_damon-005.spec_adult-001-7days-bg.in_45.log
#bbs_towards-001.spec_adult-001-night-bg.in_45.log
#bbs_towards-002.spec_adult-001-night-bg.in_45.log
#bbs_towards-004.spec_adult-001-night-bg.in_45.log
#offline_damon-001.spec_adult-001-7days-bg.in_0.log
#offline_damon-004.spec_adult-001-7days-bg.in_0.log
#offline_damon-005.spec_adult-001-7days-bg.in_0.log
#offline_towards-001.spec_adult-001-night-bg.in_0.log
#offline_towards-002.spec_adult-001-night-bg.in_0.log
#offline_towards-004.spec_adult-001-night-bg.in_0.log
#plain_damon-001.spec_adult-001-7days-bg.in_45.log
#plain_damon-004.spec_adult-001-7days-bg.in_45.log
#plain_damon-005.spec_adult-001-7days-bg.in_45.log
#plain_towards-001.spec_adult-001-night-bg.in_45.log
#plain_towards-002.spec_adult-001-night-bg.in_45.log
#plain_towards-004.spec_adult-001-night-bg.in_45.log
#reversed_damon-001-rev.spec_adult-001-7days-bg.in_45.log
#reversed_damon-004-rev.spec_adult-001-7days-bg.in_45.log
#reversed_damon-005-rev.spec_adult-001-7days-bg.in_45.log


declare -A logs=(
["reversed_damon-001-rev.spec_adult-001-7days-bg.in_45.log"]=\
"plain_damon-001.spec_adult-001-7days-bg.in_45.log"

["reversed_damon-004-rev.spec_adult-001-7days-bg.in_45.log"]=\
"plain_damon-004.spec_adult-001-7days-bg.in_45.log"

["reversed_damon-005-rev.spec_adult-001-7days-bg.in_45.log"]=\
"plain_damon-005.spec_adult-001-7days-bg.in_45.log"

#["reversed_towards-001-rev.spec_adult-001-night-bg.in_45.log"]=\
#"plain_towards-001.spec_adult-001-night-bg.in_45.log"
#
#["reversed_towards-002-rev.spec_adult-001-night-bg.in_45.log"]=\
#"plain_towards-002.spec_adult-001-night-bg.in_45.log"
#
#["reversed_towards-004-rev.spec_adult-001-night-bg.in_45.log"]=\
#"plain_towards-004.spec_adult-001-night-bg.in_45.log"

["bbs_damon-001.spec_adult-001-7days-bg.in_45.log"]=\
"plain_damon-001.spec_adult-001-7days-bg.in_45.log"

["bbs_damon-004.spec_adult-001-7days-bg.in_45.log"]=\
"plain_damon-004.spec_adult-001-7days-bg.in_45.log"

["bbs_damon-005.spec_adult-001-7days-bg.in_45.log"]=\
"plain_damon-005.spec_adult-001-7days-bg.in_45.log"

["bbs_towards-001.spec_adult-001-night-bg.in_45.log"]=\
"plain_towards-001.spec_adult-001-night-bg.in_45.log"

["bbs_towards-002.spec_adult-001-night-bg.in_45.log"]=\
"plain_towards-002.spec_adult-001-night-bg.in_45.log"

["bbs_towards-004.spec_adult-001-night-bg.in_45.log"]=\
"plain_towards-004.spec_adult-001-night-bg.in_45.log"
)

cd "$1"

for dst_log in "${!logs[@]}"; do
    src_log="${logs[$dst_log]}"
    echo "diff $src_log $dst_log"
    diff <(grep "^result" $src_log) <(grep "^result" $dst_log)
done

echo
