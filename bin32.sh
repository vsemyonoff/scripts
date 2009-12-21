#!/bin/sh

schroot -pqd "$(pwd)" -- "$@"
