#!/bin/bash

DIR_TO_CHECK="$HOME/Mail"

OLD_STAT_FILE="$HOME/Documents/mail_stat.txt"

if [ -e $OLD_STAT_FILE ]
then
        OLD_STAT=`cat $OLD_STAT_FILE`
else
        OLD_STAT="nothing"
fi

NEW_STAT=`find $DIR_TO_CHECK | grep -c $DIR_TO_CHECK`

if [ "$OLD_STAT" != "$NEW_STAT" ]
then
    echo 'Directory has changed. Do something!'
    # do whatever you want to do with the directory.
    # update the OLD_STAT_FILE
    echo $NEW_STAT > $OLD_STAT_FILE
	notify-send "Changes in your mail directory \nPreviously:    $OLD_STAT \nCurrently:    $NEW_STAT";
fi

notify-send "Changes in your mail directory \nPreviously:    $OLD_STAT \nCurrently:    $NEW_STAT";

