#!/usr/bin/env bash

exec blender -b "$1" -a -o //render >> blender.log
