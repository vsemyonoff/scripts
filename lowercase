#!/usr/bin/env bash

FROM=ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ
TO=йцукенгшщзхъфывапролджэячсмитьбюё

find . -type f | while read i
do
    DIR=`dirname "$i"`
    FILE=`basename "$i"`
    FILENEW=`echo "$FILE" | tr A-Z a-z | tr $FROM $TO`
    if [ "$FILE" != "$FILENEW" ]; then
        mv -iv "$i" "$DIR/$FILENEW"
    fi
done
