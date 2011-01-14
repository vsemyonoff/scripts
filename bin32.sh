#!/usr/bin/env bash

exec schroot -pqd "$(pwd)" -- "$@"
