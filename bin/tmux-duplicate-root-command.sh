#!/usr/bin/env bash

CURRENT_WINDOW=$(tmux display-message -p '#I')
CURRENT_SESSION=$(tmux server-info | grep -P "$CURRENT_WINDOW:.*flags.*references" -A1)
ROOT_DEV_PTS=$(echo $CURRENT_SESSION | grep -oP "/dev/pts/\d*")
ROOT_PTS=$(echo $ROOT_DEV_PTS | perl -p -e 's!/dev/!!g')
#echo $ROOT_PTS
ROOT_CMD=$(ps -ao pid,tty,args | grep $ROOT_PTS | grep -v grep | tr -s ' ' | cut -d ' ' -f3-)
eval $ROOT_CMD
