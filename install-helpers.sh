#!/bin/bash
#
# Install script for everyday-helpers.
# It offers a selection of the scripts the user wants to source (in case not all
# are to be sourced).
# Selected files are linked into a new directory `installed_scripts`.

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if ! [ "$CURRENT_DIR" = "$(pwd)" ]; then
    echo "This script needs to be run from its directory. ($CURRENT_DIR)"
    exit 1
fi

if [ -d ./installed_scripts ]; then

    # The scripts are already installed. Ask the user if the installation
    # process should be re-run.

    echo "Subdirectory 'installed_scripts' already exists."

    dialog --title "Re-run the installation process?" \
        --backtitle "The current installed_scripts directory will be overwritten." \
        --yesno "Do you want to re-run the installation process for helper scripts?" 7 60

    response=$?
    case $response in
        0)
            echo "Re-running installation process."
            rm -rf installed_scripts
            echo "Removed existing installed_scripts directory."
            ;;
        1 | 255)
            echo "Aborted."
            exit
            ;;
    esac
fi

# Create new directory for scripts that are to be used
mkdir ./installed_scripts
echo "Subdirectory installed_scripts has been created."

# Offer all files in ./scripts subdirectory for selection

let i=0
W=()
while read -r line; do
    let i=$i+1
    W+=($i "$line" ON)
done < <( ls -1 ./scripts )
SELECTED_SCRIPTS=$(dialog --title "Select scripts to source" --checklist "Chose one" 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3) # show dialog and store output
clear

# Link the selected scripts into an appropriate subdirectory.

echo "$(tput bold)Linking selected scripts into subdirectory installed_scripts$(tput sgr0)"
echo ""

WORKING_DIR=`pwd`
for SELECTED_SCRIPT in $SELECTED_SCRIPTS; do
    SELECTED_FILE_NAME=$(ls scripts | head -n $SELECTED_SCRIPT | tail -n 1 )
    ln -s "$WORKING_DIR/scripts/$SELECTED_FILE_NAME" "installed_scripts/"
    echo "Linked script $SELECTED_FILE_NAME into installed_scripts subdirectory"
done

echo ""
echo "$(tput bold)Done$(tput sgr0)"
