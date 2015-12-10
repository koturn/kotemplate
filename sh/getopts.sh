#!/bin/sh -eu

show_usage() {
  echo '[USAGE]'
  echo "  $0 SRC [ARGS...]"
}

echo '[Specified options]'
while getopts abc:h OPT; do
  case $OPT in
    a)
      echo a
      ;;
    d)
      echo b
      ;;
    c)
      echo c $OPTARG
      ;;
    h)
      show_usage
      exit 0
      ;;
    \?)
      show_usage >&2
      exit 1
      ;;
  esac
done

echo '[Remainings]'
shift $(( $OPTIND - 1 ))
echo $# $@

if [ $# -lt 1 ]; then
  echo 'Invalid arguments' >&2
  show_usage
  exit 1
fi

<+CURSOR+>
