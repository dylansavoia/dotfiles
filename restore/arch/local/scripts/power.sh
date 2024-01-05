#!/bin/bash

rofi_command="rofi -theme themes/powermenu.rasi"

### Options ###
power_off=""
suspend=""
reboot=""
lock=""
changeuser=""

# Variable passed to rofi
options="$power_off\n$reboot\n$suspend\n$lock\n$changeuser"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2 -mesg `date +%H:%M` )"
case $chosen in
    $power_off)
        shutdown now ;;
    $reboot)
        reboot ;;
    $suspend)
        systemctl suspend ;;
    $lock)
        dm-tool lock;;
    $changeuser)
        dm-tool switch-to-greeter;;
esac
