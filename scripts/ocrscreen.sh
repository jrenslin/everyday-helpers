#!/bin/bash

# A small script that automates the process of taking a screenshot and then
# running OCR on it
# Relies on gnome-screenshot, imagemagick and tesseract.
#
# Optionally - and in case Japanese is the text's language - a translation
# suggestion can be fetched from Google Translate through translate-shell
# 2017 - Joshua Enslin

t=$( date +%T )
bold=$(tput bold)
normal=$(tput sgr0)

if [ -n $1 ]; then
    LANG="$1"
elif [ -z $1 ]; then
    LANG="eng"
fi

# Ensure that required dependencies are installed.

DEPENDENCIES=(
    gnome-screenshot
    mogrify
    tesseract
)

for DEPENDENCY in "${DEPENDENCIES[@]}"
do
    if ! [ -x "$(command -v $DEPENDENCY)" ]; then
        echo "This script depends on ${bold}$DEPENDENCY${normal}. It is not available."
        exit 1
    fi
done

# Make the screenshot and save it upsized and grayscaled to /tmp

gnome-screenshot -a -f "/tmp/to_ocr_$t.png" 2> /dev/null
mogrify -resize 300%  "/tmp/to_ocr_$t.png"
mogrify -colorspace Gray  "/tmp/to_ocr_$t.png"

# Run tesseract on the image

tesseract "/tmp/to_ocr_$t.png" "/tmp/ocred_$t" -l "$LANG" >> /dev/null

# Print output

echo -e "${bold}\n--------- Output ---------\n${normal}"
RESULT=`tr -d '\n' <  "/tmp/ocred_$t.txt"`
echo $RESULT
echo ""

# If trans (translate-shell // https://github.com/soimort/translate-shell) is available

if [ -x "$(command -v trans)" ]; then
    if [ "$LANG" = "jpn" ]; then
        echo -e "${bold}\n--------- Suggested translation ---------\n${normal}"
        trans -s ja "$result"
    fi
fi
