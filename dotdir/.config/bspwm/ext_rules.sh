#!/bin/bash

wid=$1
class=$2
instance=$3

case "$class" in
    bpython)
        echo "desktop = 0 follow = on"
        ;;
    qutebrowser)
        sleep 0.5
        title=`xprop -id $wid WM_NAME`
        if [[ "$title" == *"keep.google"* || "$title" == *"calendar.google"* ]]; then
            echo "desktop = 1"
        fi
        ;;
    *)
        desktop=`bspc query -D -d focused --names`
        if [[ $desktop == "6" || $desktop == "1" ]]; then
            sendTo=`bspc query -D -d any.!focused.!occupied.local --names`
            [[ $sendTo == "" ]] && sendTo=`bspc query -D -d any.!focused.local --names`
            echo "desktop = $sendTo follow = on"
        fi
esac
