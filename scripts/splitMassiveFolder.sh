#!/bin/bash
#
# This script moves the contents of a folder with many files into
# subdirectories with a given number of files each.

if [ -n $1 ]; then
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "The argument needs to be numeric".
        exit 1
    else
        SUBDIR_SIZE="$1"
    fi
elif [ -z $1 ]; then
    LANG="eng"
    SUBDIR_SIZE=400
fi

CURRENT_DIR=`pwd`   # The current working directory will be split.
COUNTER=1           # Counter for which file this is.
SUBFOLDER=1

echo "$(tput bold)$(tput smul)Setting out to split folder $CURRENT_DIR into subdirectories of $SUBDIR_SIZE entries each.$(tput sgr0)"

for CUR_FILE in "$CURRENT_DIR"/*.*; do
    if [ ! -d $CURRENT_DIR/$SUBFOLDER ]; then
        mkdir -p $CURRENT_DIR/$SUBFOLDER
    fi
    mv $CUR_FILE $CURRENT_DIR/$SUBFOLDER
    echo "Moved file $CUR_FILE to subdirectory $SUBFOLDER"
    if [[ "$(expr "$COUNTER" % "$SUBDIR_SIZE")" -eq "0" ]]; then
        echo ""
        echo "$(tput bold)The folder $SUBFOLDER now has $SUBDIR_SIZE entries. Moving on to the next.$(tput sgr0)"
        ((SUBFOLDER++))
    fi
    ((COUNTER++))
done

