#!/bin/sh

exec schroot -pqd "$(pwd)" -- "$@"
