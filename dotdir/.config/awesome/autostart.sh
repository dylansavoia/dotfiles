#!/usr/bin/env bash

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

# Desktop effects
run picom --experimental-backends --config ~/.config/picom/picom.conf

setxkbmap -layout "us,it" -option "grp:alt_shift_toggle,caps:swapescape" &
xset r rate 200 30 &
xset m 10 50
laser -r
run redshift &

# Sys Tray
run syncthing -no-browser
run pasystray

# Turns out a chassis_type = 3 is a desktop
if [[ $(</sys/class/dmi/id/chassis_type) != 3 ]]; then
    run cbatticon
    run nm-applet
fi
