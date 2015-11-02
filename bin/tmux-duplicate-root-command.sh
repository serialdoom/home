#!/usr/bin/env bash

# this does not work if window is '0'.
# but i never use window '0'


function log {
    echo "$@" >> /tmp/tmux.log
}

CURRENT_WINDOW=$(tmux display-message -p '#I')
log "current window [$CURRENT_WINDOW]"
CURRENT_SESSION=$(tmux server-info | grep -P "$CURRENT_WINDOW:.*flags.*references" -A1)
log "current session [$CURRENT_SESSION]"
ROOT_DEV_PTS=$(echo $CURRENT_SESSION | grep -oP "/dev/pts/\d*")
log "root dev pts [$ROOT_DEV_PTS]"
ROOT_PTS=$(echo $ROOT_DEV_PTS | perl -p -e 's!/dev/!!g')
log "root pts [$ROOT_PTS]"
ROOT_CMD=$(ps -ao pid,tty,args | grep $ROOT_PTS | grep -v grep | tr -s ' ' | perl -p -e 's/^\s*//' | cut -d ' ' -f3-)
eval $ROOT_CMD
log "root cmd [$ROOT_CMD][$?]"
[ $? -ne 0 ] && /usr/bin/env bash
[ "$ROOT_CMD" == "" ] && /usr/bin/env bash
