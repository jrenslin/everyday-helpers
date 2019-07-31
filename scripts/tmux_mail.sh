#!/bin/bash
#
# This script sets up a tmux session for working with:
# - mail
# - calendar
# - to-dos
# - news
# - IRC
SESSION="Office"

WINDOW_COUNTER=1
MAIL_COMMAND="mutt"
MAIL_SYNC_COMMAND="syncinfo"
CALENDAR_COMMAND="ikhal"
TODO_COMMAND="task"
NEWS_COMMAND="newsboat"
IRC_COMMAND="weechat"

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

# Setup a window for mutt
tmux rename-window -t $SESSION:1 'Mail'
tmux send-keys "$MAIL_COMMAND" C-m

tmux split-window -v

tmux send-keys "$MAIL_SYNC_COMMAND"
tmux resize-pane -D 100

tmux select-pane -t 1

# Setup a window for calendar
if [ -x "$(command -v $CALENDAR_COMMAND)" ]; then
    ((WINDOW_COUNTER++))
    tmux new-window -t $SESSION:$WINDOW_COUNTER -n 'Calendar'
    tmux send-keys "$CALENDAR_COMMAND" C-m
fi

# Setup a window for to-dos
if [ -x "$(command -v $TODO_COMMAND)" ]; then
    ((WINDOW_COUNTER++))
    tmux new-window -t $SESSION:$WINDOW_COUNTER -n 'Tasks'
    tmux send-keys "$TODO_COMMAND" C-m
fi

# Setup a window for news readings
if [ -x "$(command -v $NEWS_COMMAND)" ]; then
    ((WINDOW_COUNTER++))
    tmux new-window -t $SESSION:$WINDOW_COUNTER -n 'News'
    tmux send-keys "$NEWS_COMMAND" C-m
fi

# Setup a window for chatting
if [ -x "$(command -v $IRC_COMMAND)" ]; then
    ((WINDOW_COUNTER++))
    tmux new-window -t $SESSION:$WINDOW_COUNTER -n 'IRC'
    tmux send-keys "$IRC_COMMAND" C-m
fi

# Set default window
tmux select-window -t $SESSION:1

# Attach to session if requested
if [[ "$1" == "attach" ]]; then
    tmux -2 attach-session -t $SESSION
fi
