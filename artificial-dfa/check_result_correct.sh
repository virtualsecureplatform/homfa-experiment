#!/usr/bin/bash -eu

declare -A logs=(
    ["reversed_size-0010_size-10000bit.log"]="plain_size-0010_size-10000bit.log"
    ["reversed_size-0010_size-20000bit.log"]="plain_size-0010_size-20000bit.log"
    ["reversed_size-0010_size-30000bit.log"]="plain_size-0010_size-30000bit.log"
    ["reversed_size-0010_size-40000bit.log"]="plain_size-0010_size-40000bit.log"
    ["reversed_size-0010_size-50000bit.log"]="plain_size-0010_size-50000bit.log"
    ["reversed_size-0100_size-10000bit.log"]="plain_size-0100_size-10000bit.log"
    ["reversed_size-0100_size-20000bit.log"]="plain_size-0100_size-20000bit.log"
    ["reversed_size-0100_size-30000bit.log"]="plain_size-0100_size-30000bit.log"
    ["reversed_size-0100_size-40000bit.log"]="plain_size-0100_size-40000bit.log"
    ["reversed_size-0100_size-50000bit.log"]="plain_size-0100_size-50000bit.log"
    ["reversed_size-0500_size-10000bit.log"]="plain_size-0500_size-10000bit.log"
    ["reversed_size-0500_size-20000bit.log"]="plain_size-0500_size-20000bit.log"
    ["reversed_size-0500_size-30000bit.log"]="plain_size-0500_size-30000bit.log"
    ["reversed_size-0500_size-40000bit.log"]="plain_size-0500_size-40000bit.log"
    ["reversed_size-0500_size-50000bit.log"]="plain_size-0500_size-50000bit.log"
    ["reversed_size-1000_size-10000bit.log"]="plain_size-1000_size-10000bit.log"
    ["reversed_size-1000_size-20000bit.log"]="plain_size-1000_size-20000bit.log"
    ["reversed_size-1000_size-30000bit.log"]="plain_size-1000_size-30000bit.log"
    ["reversed_size-1000_size-40000bit.log"]="plain_size-1000_size-40000bit.log"
    ["reversed_size-1000_size-50000bit.log"]="plain_size-1000_size-50000bit.log"
)

cd "$1"

for dst_log in "${!logs[@]}"; do
    src_log="${logs[$dst_log]}"
    echo "diff $src_log $dst_log"
    diff <(grep "^result" $src_log) <(grep "^result" $dst_log)
done

echo
