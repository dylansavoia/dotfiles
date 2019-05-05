#!/bin/bash

xrdb ~/.Xresources
pkill dunst
~/.config/dunst/cvt_template.sh
i3-msg restart
sleep 1 && (~/.config/i3/scripts/polybar &)
