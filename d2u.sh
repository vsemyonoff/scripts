#!/usr/bin/env bash

for i in *;
do
    if [ -d $i ]; then
    cd $i
    d2u
    cd ..
    elif [ -f $i ]; then
    dos2unix $i
    iconv -f cp866 -t cp1251 $i > iconv.tmp
    rm -f $i
    mv iconv.tmp $i
    fi
done
