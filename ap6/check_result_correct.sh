#!/usr/bin/bash -eu

cd "$1"
diff \
    <(grep "result" plain_towards-001.spec_adult-001-night-bg.in.log) \
    <(grep "result" qtrlwe2_towards-001.spec_adult-001-night-bg.in.log)
diff \
    <(grep "result" plain_towards-001.spec_adult-001-night-bg.in.log) \
    <(grep "result" reversed_towards-001-rev.spec_adult-001-night-bg.in.log)

