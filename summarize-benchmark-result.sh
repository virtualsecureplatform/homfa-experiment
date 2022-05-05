#!/usr/bin/bash -eu

# Thanks to: https://b.ueda.tech/?post=05953
# Thanks to: https://intoli.com/blog/exit-on-errors-in-bash-scripts/
set -o pipefail
on_debug(){
    last_command=$current_command
    current_command=$BASH_COMMAND
}
on_err(){
    echo "\"${last_command}\" command filed with exit code $?."
}
current_command=""
last_command=""
trap on_debug DEBUG
trap on_err ERR

print_error(){
  # Thanks to: https://stackoverflow.com/a/23550347
  echo
  echo -e "\e[1;31m[ERROR]\e[0m $@" >&2
  echo
}

failwith(){
  print_error "$@"
  exit 1
}

[ $# -eq 1 ] || failwith "Usage: $0 LOG-FILE"

logfilename=$1

cat $logfilename | awk -F',' '
    /^run/ { run += $2 }
    /^time_recorder-circuit_bootstrapping/ { cb += $3 }
    /^time_recorder-cmux/ { cmux += $3 }
    /^time_recorder-bootstrapping/ { bs += $3 }
    END {
        printf "Runtime (total): %.2f (s)\n", (run/1000/1000);
        printf "    CMux:                 %.3f (s)\n", (cmux/1000/1000);
        printf "    Bootstrapping:        %.3f (s)\n", (bs/1000/1000);
        printf "    CircuitBootstrapping: %.3f (s)\n", (cb/1000/1000);
    }'
