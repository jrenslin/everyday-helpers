#!/bin/bash
#
# This is a wrapper around ocrmypdf, that promts the user to enter metadata for
# a file and then OCR it. It then replaces the original file with the output file.
#

# Ensure that ocrmypdf is available.

if ! [ -x "$(command -v ocrmypdf)" ]; then
    echo "This script depends on ocrmypdf. It is not available."
    exit 1
fi

# Ensure that the input file exists

if [ -n $1 ] && [ -f "$1" ]; then
    FILE="$1"
else
    echo "This script requires the filename of an existing file as an input parameter."
    exit 1
fi

# Let the user enter PDF metadata

METADATA_TITLE=$(\
    dialog --clear \
        --backtitle "Set the title of $FILE" \
        --title "Title" \
        --inputbox "Title to be set for file $FILE" 8 50 \
        3>&1 1>&2 2>&3 3>&- \
)

METADATA_AUTHOR=$(\
    dialog --clear \
        --backtitle "Set the author of $FILE" \
        --title "Author" \
        --inputbox "Author to be set for file $FILE" 8 50 \
        3>&1 1>&2 2>&3 3>&- \
)

METADATA_SUBJECT=$(\
    dialog --clear \
        --backtitle "Set the subject / description of $FILE" \
        --title "Subject" \
        --inputbox "Description to be set for file $FILE" 8 50 \
        3>&1 1>&2 2>&3 3>&- \
)

METADATA_KEYWORDS=$(\
    dialog --clear \
        --backtitle "Set the keywords of $FILE" \
        --title "Keywords" \
        --inputbox "Keywords to be set for file $FILE" 8 50 \
        3>&1 1>&2 2>&3 3>&- \
)

# Run ocrmypdf

ocrmypdf \
    --title="$METADATA_TITLE" \
    --author="$METADATA_AUTHOR" \
    --subject="$METADATA_SUBJECT" \
    --keywords="$METADATA_KEYWORDS" \
    --skip-text \
    $FILE \
    $FILE.tmp

# Replace the original file with the output file.

if [ -f $FILE.tmp ]; then
    rm -f $FILE
    mv $FILE.tmp $FILE
    echo "Finished OCR of $FILE"
fi

