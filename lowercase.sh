#!/bin/sh

FROM=ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ
TO=йцукенгшщзхъфывапролджэячсмитьбюё

for f in *;
do
	if [ -d "$f" ]; then
		cd "$f"
		lowercase
		cd ..
		if [ "$f" != "`echo \"$f\" | tr A-Z a-z | tr $FROM $TO`" ]; then
	    	mv -iv "$f" "`echo \"$f\" | tr A-Z a-z | tr $FROM $TO`"
		fi
	elif [ -f "$f" ]; then
		if [ "$f" != "`echo \"$f\" | tr A-Z a-z | tr $FROM $TO`" ]; then
	    	mv -iv "$f" "`echo \"$f\" | tr A-Z a-z | tr $FROM $TO`"
		fi
    fi
done
