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

# Network manager tray icon
run nm-applet

setxkbmap -layout "us,it" -option "grp:alt_shift_toggle" &
xset r rate 200 30 &
xset m 10 50
setxkbmap -option caps:swapescape &


# Sys Tray
run dropbox
run pasystray
run cbatticon
