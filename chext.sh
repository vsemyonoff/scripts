#!/usr/bin/env bash

for i in `find . -type f -name *.$1`;
do
  mv -v "$i" ${i%%.$1}.$2
done
