#!/usr/bin/bash -eu

declare -A logs=(
    ["bbs_size-0010_size-10000bit.log"]="plain_size-0010_size-10000bit.log"
    ["qtrlwe2_size-0010_size-10000bit.log"]="plain_size-0010_size-10000bit.log"
    ["reversed_size-0010_size-10000bit.log"]="plain_size-0010_size-10000bit.log"
)

cd "$1"

for dst_log in "${!logs[@]}"; do
    src_log="${logs[$dst_log]}"
    echo "diff $src_log $dst_log"
    diff <(grep "^result" $src_log) <(grep "^result" $dst_log)
done

echo
