#!/bin/sh

find . | egrep -i '.(bak|~)$'| xargs rm -v
