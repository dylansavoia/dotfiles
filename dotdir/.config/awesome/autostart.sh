#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of AwesomeWM
# TODO: run_once

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

# Desktop effects
run compton --config ~/.config/compton/compton.conf

setxkbmap -layout "us,it" -option "grp:alt_shift_toggle" &
xset r rate 200 30 &
xset m 10 50
setxkbmap -option caps:swapescape &
laser -r
run redshift &

# Sys Tray
run dropbox
run pasystray

# Turns out a chassis_type = 3 is a desktop
if [[ $(</sys/class/dmi/id/chassis_type) != 3 ]]; then
    run cbatticon
    run nm-applet
fi
