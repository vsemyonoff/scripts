#!/usr/bin/env bash

comm -13 <(pacman32 -Qqm | sort) <(pacman32 -Qet | sort)
