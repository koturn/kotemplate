#!/bin/sh

set -eu

if [ $# -lt 1 ]; then
  echo Invalid arguments 1>&2
  echo [USAGE]
  echo   $0 SRC [ARGS...]
  exit 1
fi

echo Hello World!
<+CURSOR+>
