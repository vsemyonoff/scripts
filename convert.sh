#!/usr/bin/env bash

usage() {
  echo "usage: $0 from_encoding to_encoding"
  echo ""
  echo "Recursive converts filenames encoding in current directory"
  echo "and all subdirectoryes:"
  echo "    from_encoding - current filename encoding"
  echo "    to_encoding   - required filename encoding"
  echo ""
  exit 1
}


recode() {
  newname=`echo "$1" | iconv -f $FROM -t $TO`
  [ ! $? == 0 ] && exit 1
  if [ ! "$1" ==  "$newname" ]; then
    mv -iv "$1" "$newname"
    [ ! $? == 0 ] && exit 1
  fi
}

main() {
  ls | while read f
  do
    if [ -d "$f" ]; then
      cd "$f"
      main
      cd ..
    fi
    recode "$f"
  done
}

if [ ! $# == 2 ]; then
  usage
else
  FROM="$1"
  TO="$2"
  main
fi
