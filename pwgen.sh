#!/usr/bin/env bash

< /dev/urandom tr -dc A-Za-z0-9_ | head -c8
