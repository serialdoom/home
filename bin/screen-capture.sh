#!/usr/bin/env bash
#timestamp="$(date +%Y%m%dT%H%M%S)"
#targetbase="$HOME/capscr"
#mkdir -p $targetbase
#[ -d $targetbase ] || exit 1
#import -window root $targetbase/$timestamp.png

activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
activeWinId=${activeWinLine:40}
import -window "$activeWinId" /tmp/$(date +%F_%H%M%S_%N).png
