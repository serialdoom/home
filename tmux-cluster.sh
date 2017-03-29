#!/usr/bin/env bash

tmux split-window 'bash -c "ash m003;"'
tmux split-window 'bash -c "ash m004;"'
tmux split-window 'bash -c "ash m005;"'
tmux split-window 'bash -c "ash m006;"'
tmux select-layout even-vertical
tmux set-window synchronize-panes
