#!/usr/bin/env bash

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

# Desktop effects
run picom -b --experimental-backends --config ~/.config/picom/picom.conf

setxkbmap -layout "us,it" -option "grp:alt_shift_toggle,caps:swapescape" &
xset r rate 200 30 &
xset m 2 100
laser -r
run redshift
run unclutter --timeout 5

# Sys Tray
run syncthing -no-browser
run pasystray
run nm-applet

# Turns out a chassis_type = 3 is a desktop
if [[ $(</sys/class/dmi/id/chassis_type) != 3 ]]; then
    run cbatticon
fi

# Startup Applications
# run $BROWSER "https://calendar.google.com/calendar/u/0/r?pli=1" "https://dylansavoia.sytes.net/Main/Apps/TextEdit/index.php?f=%2FNotes%2FToDo%2FTODO" &
