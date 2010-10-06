#!/usr/bin/env bash

comm -13 <(pacman -Qqm | sort) <(pacman -Qet | sort)
