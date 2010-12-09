#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "usage: $0 path_to_source"
    exit 1
fi

cmake -LH "$1"
