#!/bin/bash

cmd=''
path=''
while test $# -gt 0; do
  case "$1" in
    --conda)
      shift
      if test $# -gt 0; then
        cmd="conda_init; conda activate $1; $cmd"
      fi
      shift
      ;;
    --path)
      shift
      if test $# -gt 0; then
        path="$1"
      fi
      shift
      ;;
  esac
done

if [[ "$path" == '' ]]; then
    path="$PWD"
fi
cmd="cd $path; $cmd"

echo "$cmd"
echo "$cmd" > "/tmp/current_project"
