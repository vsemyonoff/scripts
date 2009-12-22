#!/bin/sh

find . -type f -regex "\./.*\(\.bak\|\~\)$" -exec rm -v {} \+
