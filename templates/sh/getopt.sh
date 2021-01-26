#!/bin/sh

set -eu

show_usage() {
  echo '[Usage]'
  echo "  $0 [options] [arguments]"
  echo '[Option]'
  echo '  -a, --apple'
  echo '    This is an apple'
  echo '  -b, --banana'
  echo '    This is an banana'
  echo '  -c ARG, --cake=ARG'
  echo '    This is an cake with argument'
  echo '  -h, --help'
  echo '    Show help and exit'
}

unset GETOPT_COMPATIBLE
OPT=`getopt -o abc:h -l apple,banana,cake:,help -- "$@"`
if [ $? -ne 0 ]; then
  echo >&2 'Invalid argument'
  show_usage >&2
  exit 1
fi

eval set -- "$OPT"

while [ $# -gt 0 ]; do
  case $1 in
    -a | --apple)
      echo 'apple'
      ;;
    -b | --banana)
      echo 'banana'
      ;;
    -c | --cake)
      echo "cake $2"
      shift;;
    -h | --help)
      show_usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
  esac
  shift
done
