#!/bin/bash
#
# This script provides a quick summary of folder contents.
# Information presented includes:
# - Total size of the folder's contents
# - Whether the directory is git-controlled
# - Number of files of different types in the directory
#
# If gnuplot is available, a bar chart for visualizing the distribution of file
# types will be shown.
#

##### Functions

bold=$(tput bold)
underline=$(tput smul)
normal=$(tput sgr0)
red=$(tput setaf 1)
bgred=$(tput setab 1)
green=$(tput setaf 2)
bggreen=$(tput setab 2)
blue=$(tput setaf 4)
bgblue=$(tput setab 4)
cyan=$(tput setaf 6)
bgcyan=$(tput setab 6)

emphasize() {
    echo "${bold}$1${normal}"
    echo ""
}

numberFolderContents() {

    ARRAY=("$@")
    OUTPUT_NO=0
    for i in "${ARRAY[@]}"
    do
        OUTPUT_NO=`echo "$OUTPUT_NO + $(find . -name "*$i" -type f | wc -l)" | bc`
    done

    echo $OUTPUT_NO

}

##### Retrieve information on the folder

# Get total size of folder contents
FOLDER_CONTENTS_SIZE_TOTAL=`du -sh .`

# Find out if the directory is git-controlled
DIR_GIT_CONTROLLED=""
if ! [ -x "$(command -v git)" ]; then
    DIR_GIT_CONTROLLED="${bgred}Git is not available.${normal}"
else
    DIR_GIT_FOLDER=`git rev-parse --git-dir 2> /dev/null`
     if [ -n "$DIR_GIT_FOLDER" ]; then
        DIR_GIT_CONTROLLED="${bold}${green}The directory is git controlled.${normal}"
     else
        DIR_GIT_CONTROLLED="${bold}${red}The directory is not git controlled.${normal}"
     fi
fi

# Get output of du for every subfolder
# FOLDER_CONTENTS_SIZE_SUBFOLDERS_RAW=`du -sh ./*`

FILETYPES_IMAGES=(
    .png
    .jpg
    .jpeg
    .gif
    .bmp
    .psd
    .xcf
)

FILETYPES_TEXT=(
    .doc
    .docx
    .odt
)

FILETYPES_PLAIN_TEXT=(
    .txt
    .htm
    .md
    .org
)

FILETYPES_CODE=(
    .sh
    .rs
    .rb
    .js
    .css
    .php
    .py
)

FILETYPES_PDF_EBOOK=(
    .pdf
    .epub
)

FILETYPES_SPREADSHEETS=(
    .xls
    .xlsx
    .ods
)

FILETYPES_AUDIO=(
    .mp3
    .m4a
    .ogg
    .opus
)

FILETYPES_VIDEO=(
    .mp4
    .mkv
    .webm
)

FILETYPES_DATA=(
    .xml
    .rdf
    .json
)

FILETYPES_CONFIG=(
    .conf
)

FILETYPES_ARCHIVE=(
    .zip
    .rar
    .tar
)


# Calculate number of files (total)
FILES_SUM_TOTAL=`find -name "*.*" -type f | wc -l`

# Calculate number of files by type
FILES_SUM_IMAGES=$(numberFolderContents "${FILETYPES_IMAGES[@]}")
FILES_SUM_TEXT=$(numberFolderContents "${FILETYPES_IMAGES[@]}")
FILES_SUM_PLAIN_TEXT=$(numberFolderContents "${FILETYPES_PLAIN_TEXT[@]}")
FILES_SUM_CODE=$(numberFolderContents "${FILETYPES_CODE[@]}")
FILES_SUM_PDF_EBOOK=$(numberFolderContents "${FILETYPES_PDF_EBOOK[@]}")
FILES_SUM_SPREADSHEETS=$(numberFolderContents "${FILETYPES_SPREADSHEETS[@]}")
FILES_SUM_AUDIO=$(numberFolderContents "${FILETYPES_AUDIO[@]}")
FILES_SUM_VIDEO=$(numberFolderContents "${FILETYPES_VIDEO[@]}")
FILES_SUM_DATA=$(numberFolderContents "${FILETYPES_DATA[@]}")
FILES_SUM_CONFIG=$(numberFolderContents "${FILETYPES_CONFIG[@]}")
FILES_SUM_ARCHIVE=$(numberFolderContents "${FILETYPES_ARCHIVE[@]}")
FILES_SUM_OTHER=$(echo "$FILES_SUM_TOTAL - $FILES_SUM_IMAGES - $FILES_SUM_TEXT - $FILES_SUM_PLAIN_TEXT - $FILES_SUM_CODE - $FILES_SUM_PDF_EBOOK - $FILES_SUM_SPREADSHEETS - $FILES_SUM_AUDIO - $FILES_SUM_VIDEO - $FILES_SUM_DATA - $FILES_SUM_CONFIG - $FILES_SUM_ARCHIVE" | bc)

# Calculate percentages
FILES_PERCENTAGE_IMAGES=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_IMAGES" | bc)
FILES_PERCENTAGE_TEXT=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_TEXT" | bc)
FILES_PERCENTAGE_PLAIN_TEXT=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_PLAIN_TEXT" | bc)
FILES_PERCENTAGE_CODE=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_CODE" | bc)
FILES_PERCENTAGE_PDF_EBOOK=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_PDF_EBOOK" | bc)
FILES_PERCENTAGE_SPREADSHEETS=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_SPREADSHEETS" | bc)
FILES_PERCENTAGE_AUDIO=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_AUDIO" | bc)
FILES_PERCENTAGE_VIDEO=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_VIDEO" | bc)
FILES_PERCENTAGE_DATA=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_DATA" | bc)
FILES_PERCENTAGE_CONFIG=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_CONFIG" | bc)
FILES_PERCENTAGE_ARCHIVE=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_ARCHIVE" | bc)
FILES_PERCENTAGE_OTHER=$(echo "scale=2; 100 / $FILES_SUM_TOTAL * $FILES_SUM_OTHER" | bc)

##### Output

# Determine format

COLUMNS=`tput cols`
FORMAT_BASE="${bold}${bgblue}%-14s${normal}${bggreen}${bold}%6s${normal}${bgcyan} %4.1f%%${normal}"
USEDCOLUMNS=$COLUMNS
if [ "$COLUMNS" -gt "240" ]; then
    FORMAT="$FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE \n"
elif [ "$COLUMNS" -gt "130" ]; then
    FORMAT="$FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE \n"
    USEDCOLUMNS=130
elif [ "$COLUMNS" -gt "100" ]; then
    FORMAT="$FORMAT_BASE | $FORMAT_BASE | $FORMAT_BASE \n"
    USEDCOLUMNS=100
elif [ "$COLUMNS" -gt "60" ]; then
    FORMAT="$FORMAT_BASE | $FORMAT_BASE \n"
    USEDCOLUMNS=60
else
    FORMAT="$FORMAT_BASE \n"
    USEDCOLUMNS=30
fi

# Print summary

emphasize "Folder summary for $(pwd)"
echo "${bold}Folder size: ${underline}$FOLDER_CONTENTS_SIZE_TOTAL${normal}"
echo "$DIR_GIT_CONTROLLED"

printf "$FORMAT" \
    "Images" $FILES_SUM_IMAGES $FILES_PERCENTAGE_IMAGES \
    "Text" $FILES_SUM_TEXT $FILES_PERCENTAGE_TEXT \
    "Plain text" $FILES_SUM_PLAIN_TEXT $FILES_PERCENTAGE_PLAIN_TEXT \
    "Code" $FILES_SUM_CODE $FILES_PERCENTAGE_CODE \
    "PDF+Ebooks" $FILES_SUM_PDF_EBOOK $FILES_PERCENTAGE_PDF_EBOOK \
    "Spreadsheets" $FILES_SUM_SPREADSHEETS $FILES_PERCENTAGE_SPREADSHEETS \
    "Audio" $FILES_SUM_AUDIO $FILES_PERCENTAGE_AUDIO \
    "Video" $FILES_SUM_VIDEO $FILES_PERCENTAGE_VIDEO \
    "Data" $FILES_SUM_DATA $FILES_PERCENTAGE_DATA \
    "Config" $FILES_SUM_CONFIG $FILES_PERCENTAGE_CONFIG \
    "Archives" $FILES_SUM_ARCHIVE $FILES_PERCENTAGE_ARCHIVE \
    "Other" $FILES_SUM_OTHER $FILES_PERCENTAGE_OTHER

if [ -x "$(command -v gnuplot)" ]; then
    printf "%s,%s,%s\n" \
        "Images" $FILES_SUM_IMAGES $FILES_PERCENTAGE_IMAGES \
        "Text" $FILES_SUM_TEXT $FILES_PERCENTAGE_TEXT \
        "Plain" $FILES_SUM_PLAIN_TEXT $FILES_PERCENTAGE_PLAIN_TEXT \
        "Code" $FILES_SUM_CODE $FILES_PERCENTAGE_CODE \
        "PDF/Ebook" $FILES_SUM_PDF_EBOOK $FILES_PERCENTAGE_PDF_EBOOK \
        "Spreadsheets" $FILES_SUM_SPREADSHEETS $FILES_PERCENTAGE_SPREADSHEETS \
        "Audio" $FILES_SUM_AUDIO $FILES_PERCENTAGE_AUDIO \
        "Video" $FILES_SUM_VIDEO $FILES_PERCENTAGE_VIDEO \
        "Data" $FILES_SUM_DATA $FILES_PERCENTAGE_DATA \
        "Config" $FILES_SUM_CONFIG $FILES_PERCENTAGE_CONFIG \
        "Archives" $FILES_SUM_ARCHIVE $FILES_PERCENTAGE_ARCHIVE \
        "Other" $FILES_SUM_OTHER $FILES_PERCENTAGE_OTHER | gnuplot -p -e "
        set terminal dumb $USEDCOLUMNS 15;
        set style data boxes;
        set style fill solid noborder;
        set boxwidth 0.95;
        set key inside right top vertical Right noreverse noenhanced autotitle nobox;
        set style textbox transparent margins  1.0,  1.0 border;
        set yrange [0:$FILES_SUM_TOTAL];
        unset logscale;
        unset xtics;
        set xtics  norangelimit;
        set title 'Number of files by type in the folder';
        set datafile separator \",\";
        plot '< cat -' using 2:xtic(1) with boxes"
fi
