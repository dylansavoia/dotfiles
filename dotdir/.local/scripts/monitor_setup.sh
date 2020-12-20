#!/bin/bash

rofi_command="rofi -p Monitor -dmenu -i -theme themes/notification_buttons.rasi"

# Variable passed to rofi
options="Primary Only\nMirror\nExtend Left\nExtend Right\nExtend Top\nExtend Bottom"

chosen="$(echo -e "$options" | $rofi_command )"
case $chosen in
    'Primary Only')
        mons -o;;
    'Mirror')
        mons -m ;;
    *)
        dir=`echo ${chosen:7} | tr [A-Z] [a-z]`
        mons -e "$dir";;
esac
