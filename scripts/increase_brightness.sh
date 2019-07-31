#! /bin/zsh
#
# This script contains a quick and dirty solution for increasing screen
# brightness by 10 percent using xrandr.
# Currently unused, because xbacklight works on my current PCs.

# Get brightness and determine new brightness
x=`xrandr --verbose | awk '/Brightness/ { print $2; exit }' | sed 's/0.//' | sed 's/1./10/'`; x=`expr $x + 10`;

# Increase the brightness by 10 percent.
if [ "$x" -gt "99" ]
    then exec notify-send "Brightness at 100%"
    else xrandr --output eDP-1 --brightness 0.`echo $x`; exec notify-send "Brightness at $x%"
fi;

if [ "$x" -eq "100" ]
    then xrandr --output eDP-1 --brightness 1;
fi;
