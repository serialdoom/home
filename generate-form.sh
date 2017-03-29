#!/usr/bin/env bash

NAME_FILE=~/.census-derived-all-first.txt 
[ -f $NAME_FILE ] || wget http://deron.meranda.us/data/census-derived-all-first.txt -O $NAME_FILE



FIRST_NAME="$(shuf -n 1 $NAME_FILE  | tr -s ' ' | cut -d ' ' -f1)"
LAST_NAME="$(shuf -n 1 $NAME_FILE  | tr -s ' ' | cut -d ' ' -f1)$(shuf -n 1 $NAME_FILE  | tr -s ' ' | cut -d ' ' -f1)"
PASS="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-64};echo;)"
EMAIL="${FIRST_NAME}.${LAST_NAME}@email.com"

YOB=$(( 1970 + $[ $RANDOM % 20 ] ))
MOB=$((1 + $[ $RANDOM % 12 ] ))
DOB=$((1 + $[ $RANDOM % 25 ] ))


echo "$FIRST_NAME $LAST_NAME"
echo "$EMAIL"
echo "$PASS"
echo "$YOB $MOB $DOB -- $(date -d "$YOB/$MOB/$DOB")"

