#!/bin/bash
#
# This script cleans files left over from e.g. pdflatex

CURRENT_DIR=`pwd`
echo $CURRENT_DIR

# Array of leftover filetypes to remove
FILETYPES_TO_REMOVE=(
    .aux
    .blg
    .log
    .out
)

for FILETYPE in "${FILETYPES_TO_REMOVE[@]}"; do
    for CUR_FILE in *$FILETYPE; do
        rm -f "$CUR_FILE"
        echo "Removing $CUR_FILE"
    done
done
