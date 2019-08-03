#!/bin/bash
#
# This is a script for emptying history files, deleting thumbnails and removing
# other traces of use from the system.

# If no argument is given, show a help message.

if [ -z "$1" ]; then
    echo "Available arguments:

--history       Truncate history files.
--thumbnails    Empty thumbnail directories."
    exit
fi

# Offer emptying history files
# History data may be stuck in an open terminal's cache and be re-inserted into
# the relevant files from there.

if [ "$1" = "--history" ]; then

    echo "Emptying history files."

    # Build array of history files to empty
    HISTORY_FILES=(
        $HOME/.bash_history
        $HOME/.python_history
        $HOME/.sc_history
        $HOME/.zhistory
    )

    # Loop over the array and empty the files
    for HISTORY_FILE in "${HISTORY_FILES[@]}"; do

        if [ -f $HISTORY_FILE ]; then
            echo "History file $HISTORY_FILE exists. Emptying it"
            # Truncate is used here to leave potential symlinks intact.
            truncate -s 0 "$HISTORY_FILE"
        fi

    done

fi

if [ "$1" = "--thumbnails" ]; then

    # Array of thumbnail directories to empty
    THUMBNAIL_DIRS=(
        $HOME/.thumbnails/large
        $HOME/.thumbnails/normal
        $HOME/.cache/thumbnails/fail
        $HOME/.cache/thumbnails/large
        $HOME/.cache/thumbnails/normal
    )

    # Remove all files in the thumbnail directory, if it exists.
    for THUMBNAIL_DIR in "${THUMBNAIL_DIRS[@]}"; do

        if [ -d $THUMBNAIL_DIR ]; then
            echo "Thumbnail directory $THUMBNAIL_DIR found. Deleting files in it."
            #  -mtime +5 / Only files older than 5 days. Maybe useful for later expansion of the script.
            find "$THUMBNAIL_DIR" -type f -exec rm {} \;
        fi

    done

fi
