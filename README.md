Bash scripts for everyday life
==============================

This repository contains small shell scripts written for everyday tasks. The scripts themselves can be found in the `scripts` directory, from which they can be sourced into `zsh`.

```
pathdirs=(
    $HOME/Sync/Programming/everyday-helpers/scripts
)
for dir in $pathdirs; do
    if [ -d $dir ]; then
        path+=$dir
    fi
done
```

Scripts
-------

### `folderSummary.sh`

This script generates and displayes short rundowns of the contents of a folder in the terminal.

### `ocrscreen.sh`

Shortcut for taking a screenshot of a given screen region and running OCR over it.

### `ocrPDF.sh`

This is a wrapper around [`ocrmypdf`](https://github.com/jbarlow83/OCRmyPDF). It prompts the user to enter PDF metadata in `dialog` input boxes and then inserts these together with the OCRed text into the document.

### `splitMassiveFolder.sh`

This script splits a large directory by moving a its files into numbered subdirecties of a roughly equal number of files.

### `increase_brightness.sh` and `reduce_brightness.sh`

Scripts for increasing and decreasing screen brightness by ten percent. Written because `xbacklight` did not work on an old screen.

### `tmux_mail.sh`, `tmux_main.sh` and `tmux_music.sh`

These scripts open pre-defined tmux sessions.

### `jsonifyString.php` and `csvReplaceSeparator.php`

`jsonifyString.php` splits an input string into an array (based on a provided separator) and returns the array JSON-encoded. `csvReplaceSeparator.php`, based on the former, replaces the separator in the provided string by another and prints the corrected string. Written in PHP.

### `removeHistory.sh`

Bash script offering to empty history files or delete thumbnail files from a set of known thumbnail directories.

Install Script
--------------

Using the script `install-helpers.sh`, a folder `installed_scripts` can be created, into which selected scripts are symlinked. By linking this subdirectory, unneeded scripts can be prevented from cluttering your shell.
