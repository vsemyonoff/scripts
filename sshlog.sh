rm -f accepted.txt failed.txt
FILES="auth.log auth.log.1 auth.log.2 auth.log.3 auth.log.4"

for i in $FILES; do
    grep "Accepted password" $i | tac >> accepted.txt
    grep "Failed password" $i | tac >> failed.txt
done
