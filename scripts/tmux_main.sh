#!/bin/bash

# Ensure that scratchpad file exists

php ~/scripts/ensureScratchpad.php

# Handle tmux

SESSION="Main"

# Prevent double-starting.
AlreadyStarted="$(tmux list-sessions | grep $SESSION | wc -l)"
if [ "1" == "$AlreadyStarted" ]; then

    # Attach to session if requested
    if [[ "$1" == "attach" ]]; then
        tmux -2 attach-session -t $SESSION
        exit
    else
        echo "Aborting: Already started."
        exit 1
    fi

fi

tmux -2 new-session -d -s $SESSION

# Setup a window for tailing log files

tmux new-window -t $SESSION:2 -n 'System'
tmux send-keys "htop" C-m

tmux split-window -v
tmux resize-pane -y 8
tmux clock-mode

tmux split-window -h
tmux send-keys "vnstat" C-m

# Set default window
tmux select-window -t $SESSION:1

# Attach to session if requested
if [[ "$1" == "attach" ]]; then
    tmux -2 attach-session -t $SESSION
fi

