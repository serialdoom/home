#!/usr/bin/env bash

tmux split-window 'bash -c "ash $(ag "192.168.251." host_vars/ -l | shuf -n 1 | cut -d '/' -f2);"'
tmux split-window 'bash -c "ash $(ag "192.168.252." host_vars/ -l | shuf -n 1 | cut -d '/' -f2);"'
tmux split-window 'bash -c "ash $(ag "192.168.254." host_vars/ -l | shuf -n 1 | cut -d '/' -f2);"'
tmux select-layout even-vertical
tmux set-window synchronize-panes
