#!/bin/bash
#
# This script sets up a tmux session for music.
# It contains one window, which contains three panes for visualization, selection, and a clock.
SESSION="Music"
VISUALIZER="cava"
MUSIC_TOOL="ncmpcpp"

if ! [ -x "$(command -v $MUSIC_TOOL)" ]; then
    echo "Missing dependency: $MUSIC_TOOL"
    exit 1
fi

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

# Setup a window for visualizing and selecting music to listen to
tmux rename-window -t $SESSION:1 'Music'

# First pane is filled with visualization tool if it is available.
if [ -x "$(command -v $VISUALIZER)" ]; then
    tmux send-keys "$VISUALIZER" C-m
fi

tmux split-window -h
tmux resize-pane -L 40

tmux select-pane -t 2
tmux send-keys "$MUSIC_TOOL" C-m

tmux select-pane -t 1
tmux split-window -v
tmux clock-mode
tmux select-pane -t 3

# Set default window
tmux select-window -t $SESSION:2

# Attach to session if requested
if [[ "$1" == "attach" ]]; then
    tmux -2 attach-session -t $SESSION
fi
