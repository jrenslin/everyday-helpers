#! /bin/zsh

# This script contains a quick and dirty solution for reducing screen
# brightness by 10 percent using xrandr.
# Currently unused, because xbacklight works on my current PCs.

# Get the current screen brightness.
x=`xrandr --verbose | awk '/Brightness/ { print $2; exit }' | sed 's/0.//' | sed 's/1./10/'`;

# The target brightness is 10 percent below the current.
x=`expr $x - 10`;

# Decrease the brightness by 10%, but prevent it going below 20%.
if [ "$x" -lt "20" ]
    then exec notify-send "Brightness at 20%"
    else xrandr --output eDP-1 --brightness 0.`echo $x`; exec notify-send "Brightness at $x%"
fi;
