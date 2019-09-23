#!/bin/bash
#
# This script converts PNG files to PDFs.
#

# Ensure that imagemagick and PHP are available.

if ! [ -x "$(command -v convert)" ]; then
    echo "This script depends on imagemagick. It is not available."
    exit 1
fi

if ! [ -x "$(command -v php)" ]; then
    echo "This script depends on php. It is not available."
    exit 1
fi

PNG_FILES_EXIST=`ls | grep \.png | wc -l`
if ! [ "$PNG_FILES_EXIST" = "0" ]; then

    # Convert all PNG files to JPG.

    for FILENAME in ./*.png; do convert "$FILENAME" "$FILENAME.jpg"; done

    # Remove the larger one of the files.

    php -r "
    \$files = array_diff(scandir('./'), ['.', '..']);

    foreach (\$files as \$png_file) {
        if (pathinfo(\$png_file, PATHINFO_EXTENSION) !== 'png') continue;
        \$corresponding_jpg = \$png_file . '.jpg';

        \$filesize_PNG = filesize(\$png_file);
        \$filesize_JPG = filesize(\$corresponding_jpg);

        if (\$filesize_PNG > \$filesize_JPG) {
            echo \$png_file . ' is larger that ' . \$corresponding_jpg . '. Removing PNG file.' . PHP_EOL;
            unlink(\$png_file);
        }
        else {
            echo \$corresponding_jpg . ' is larger that ' . \$png_file . '. Removing JPG file.' . PHP_EOL;
            unlink(\$corresponding_jpg);
        }
    }
    "

fi

# If rename is available: Remove .png from the name of converted JPG files.

if [ -x "$(command -v rename)" ]; then
    rename 's/\.png\.jpg/\.jpg/g' *.jpg
fi

DIRECTORY_NAME=$(basename "$(pwd)")
convert * "$DIRECTORY_NAME.pdf"

exit

# Maybe for later

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -f "$CURRENT_DIR/ocrPDF.sh" ]; then
    echo "ocrPDF.sh is available. Expanding current script execution with it."
    bash "$CURRENT_DIR/ocrPDF.sh" "$DIRECTORY_NAME.pdf"
else
    echo "ocrPDF.sh is not available"
fi


