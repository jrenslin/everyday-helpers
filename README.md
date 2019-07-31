Bash scripts for everyday life
==============================

This repository contains small shell scripts I wrote for everyday tasks. The scripts themselves can be found in the `scripts` directory, from which I source them into my zsh.

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

### `increase_brightness.sh` and `reduce_brightness.sh`

Scripts for increasing and decreasing screen brightness by ten percent. Written because `xbacklight` did not work on my old screen.

### `tmux_mail.sh`, `tmux_main.sh` and `tmux_music.sh`

These scripts open pre-defined tmux sessions.
